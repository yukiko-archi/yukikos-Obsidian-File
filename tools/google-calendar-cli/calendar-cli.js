#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const http = require("http");
const readline = require("readline");
const { google } = require("googleapis");

const SCOPES = ["https://www.googleapis.com/auth/calendar"];
const DEFAULT_CREDENTIALS_PATH = path.join(__dirname, "credentials.json");
const DEFAULT_TOKEN_PATH = path.join(__dirname, "token.json");
const REDIRECT_URI = "http://127.0.0.1:3000/oauth2callback";

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i += 1) {
    const part = argv[i];
    if (!part.startsWith("--")) continue;
    const key = part.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith("--")) {
      args[key] = true;
      continue;
    }
    args[key] = next;
    i += 1;
  }
  return args;
}

function printHelp() {
  console.log(`
Google Calendar CLI

Usage:
  node calendar-cli.js auth
  node calendar-cli.js list --from "2026-05-10T00:00:00+09:00" --to "2026-05-11T00:00:00+09:00"
  node calendar-cli.js add --title "打ち合わせ" --start "2026-05-11T14:00:00+09:00" --end "2026-05-11T15:00:00+09:00" [--description "..."] [--location "..."]
  node calendar-cli.js update --id "<eventId>" [--title "..."] [--start "..."] [--end "..."] [--description "..."] [--location "..."]
  node calendar-cli.js delete --id "<eventId>"

Options:
  --calendar "<calendarId>"  (default: primary)
  --allDay                   add/update as all-day event when used with --start/--end date-only

Notes:
  - --start and --end: RFC3339 datetime (e.g. 2026-05-11T14:00:00+09:00) or date-only (YYYY-MM-DD)
  - credentials.json must exist at tools/google-calendar-cli/credentials.json
`);
}

function readJson(jsonPath) {
  return JSON.parse(fs.readFileSync(jsonPath, "utf8"));
}

function getCredentialsPath() {
  return process.env.GOOGLE_CALENDAR_CREDENTIALS || DEFAULT_CREDENTIALS_PATH;
}

function getTokenPath() {
  return process.env.GOOGLE_CALENDAR_TOKEN || DEFAULT_TOKEN_PATH;
}

function getOAuthClient() {
  const credentialsPath = getCredentialsPath();
  if (!fs.existsSync(credentialsPath)) {
    throw new Error(
      `credentials.json not found: ${credentialsPath}\nPlace OAuth client file here first.`
    );
  }

  const json = readJson(credentialsPath);
  const creds = json.installed || json.web;
  if (!creds) {
    throw new Error("Invalid credentials.json format. Missing installed/web.");
  }

  return new google.auth.OAuth2(creds.client_id, creds.client_secret, REDIRECT_URI);
}

async function loadAuthorizedClient() {
  const client = getOAuthClient();
  const tokenPath = getTokenPath();
  if (!fs.existsSync(tokenPath)) {
    throw new Error(
      `token.json not found: ${tokenPath}\nRun "node calendar-cli.js auth" first.`
    );
  }
  const token = readJson(tokenPath);
  client.setCredentials(token);
  return client;
}

function askLine(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

async function authenticate() {
  const oauth2Client = getOAuthClient();

  const authUrl = oauth2Client.generateAuthUrl({
    access_type: "offline",
    prompt: "consent",
    scope: SCOPES,
  });

  console.log("\nOpen this URL in your browser and authorize:\n");
  console.log(authUrl);
  console.log("\nWaiting for callback on http://127.0.0.1:3000/oauth2callback ...");

  const tokenPath = getTokenPath();

  const codeFromCallback = await new Promise((resolve) => {
    let handled = false;
    const server = http.createServer((req, res) => {
      const reqUrl = new URL(req.url, "http://127.0.0.1:3000");
      if (reqUrl.pathname !== "/oauth2callback") {
        res.statusCode = 404;
        res.end("Not found");
        return;
      }
      const code = reqUrl.searchParams.get("code");
      if (!code) {
        res.statusCode = 400;
        res.end("Missing code parameter");
        return;
      }
      res.end("Authorization received. You can close this tab.");
      handled = true;
      server.close(() => resolve(code));
    });

    server.listen(3000, "127.0.0.1");

    setTimeout(async () => {
      if (handled) return;
      server.close();
      const manualCode = await askLine(
        "\nIf callback failed, paste authorization code here: "
      );
      resolve(manualCode);
    }, 120000);
  });

  const { tokens } = await oauth2Client.getToken(codeFromCallback);
  oauth2Client.setCredentials(tokens);
  fs.writeFileSync(tokenPath, JSON.stringify(tokens, null, 2), "utf8");

  console.log(`\nSaved token: ${tokenPath}`);
}

function toDateTimeObj(value, allDay) {
  if (allDay) {
    return { date: value };
  }
  return { dateTime: value };
}

function ensureRequired(args, key) {
  if (!args[key]) throw new Error(`Missing required option: --${key}`);
}

async function listEvents(args) {
  const auth = await loadAuthorizedClient();
  const calendar = google.calendar({ version: "v3", auth });
  const calendarId = args.calendar || "primary";
  const timeMin = args.from || new Date().toISOString();
  const timeMax = args.to;

  const res = await calendar.events.list({
    calendarId,
    timeMin,
    timeMax,
    singleEvents: true,
    orderBy: "startTime",
    q: args.q,
    maxResults: Number(args.max || 50),
  });

  const events = res.data.items || [];
  if (events.length === 0) {
    console.log("No events found.");
    return;
  }

  for (const ev of events) {
    const start = ev.start?.dateTime || ev.start?.date || "-";
    const end = ev.end?.dateTime || ev.end?.date || "-";
    console.log(`- id: ${ev.id}`);
    console.log(`  title: ${ev.summary || "(no title)"}`);
    console.log(`  start: ${start}`);
    console.log(`  end:   ${end}`);
    if (ev.location) console.log(`  location: ${ev.location}`);
  }
}

async function addEvent(args) {
  ensureRequired(args, "title");
  ensureRequired(args, "start");
  ensureRequired(args, "end");

  const auth = await loadAuthorizedClient();
  const calendar = google.calendar({ version: "v3", auth });
  const calendarId = args.calendar || "primary";
  const allDay = Boolean(args.allDay);

  const event = {
    summary: args.title,
    description: args.description || "",
    location: args.location || "",
    start: toDateTimeObj(args.start, allDay),
    end: toDateTimeObj(args.end, allDay),
  };

  const res = await calendar.events.insert({
    calendarId,
    requestBody: event,
  });

  console.log("Event created.");
  console.log(`id: ${res.data.id}`);
  console.log(`htmlLink: ${res.data.htmlLink}`);
}

async function updateEvent(args) {
  ensureRequired(args, "id");

  const auth = await loadAuthorizedClient();
  const calendar = google.calendar({ version: "v3", auth });
  const calendarId = args.calendar || "primary";
  const allDay = Boolean(args.allDay);

  const getRes = await calendar.events.get({
    calendarId,
    eventId: args.id,
  });
  const current = getRes.data;

  const updated = {
    ...current,
    summary: args.title !== undefined ? args.title : current.summary,
    description:
      args.description !== undefined ? args.description : current.description,
    location: args.location !== undefined ? args.location : current.location,
    start:
      args.start !== undefined
        ? toDateTimeObj(args.start, allDay)
        : current.start,
    end: args.end !== undefined ? toDateTimeObj(args.end, allDay) : current.end,
  };

  const res = await calendar.events.update({
    calendarId,
    eventId: args.id,
    requestBody: updated,
  });

  console.log("Event updated.");
  console.log(`id: ${res.data.id}`);
  console.log(`htmlLink: ${res.data.htmlLink}`);
}

async function deleteEvent(args) {
  ensureRequired(args, "id");

  const auth = await loadAuthorizedClient();
  const calendar = google.calendar({ version: "v3", auth });
  const calendarId = args.calendar || "primary";

  await calendar.events.delete({
    calendarId,
    eventId: args.id,
  });

  console.log(`Event deleted: ${args.id}`);
}

async function main() {
  const command = process.argv[2];
  const args = parseArgs(process.argv.slice(3));

  if (!command || command === "help" || command === "--help") {
    printHelp();
    return;
  }

  if (command === "auth") {
    await authenticate();
    return;
  }
  if (command === "list") {
    await listEvents(args);
    return;
  }
  if (command === "add") {
    await addEvent(args);
    return;
  }
  if (command === "update") {
    await updateEvent(args);
    return;
  }
  if (command === "delete") {
    await deleteEvent(args);
    return;
  }

  throw new Error(`Unknown command: ${command}`);
}

main().catch((err) => {
  console.error("\n[ERROR]");
  console.error(err.message || err);
  process.exit(1);
});
