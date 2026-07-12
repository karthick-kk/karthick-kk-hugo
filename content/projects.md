+++
title = "Projects"
date = "2026-07-12"
aliases = ["work","works","projects"]
[ author ]
  name = "Karthick"
+++

These are the projects I'm actively building and maintaining. They range from Kubernetes platform tooling and hands-on learning platforms to AI agents, emulators, and everyday desktop apps.

### Platforms & DevOps

#### kubetrust

I built **kubetrust** as a Kubernetes mutating admission webhook that automatically injects CA certificates into pods running in labeled namespaces, integrating with cert-manager's trust-manager to consolidate system and custom CAs into a single trust bundle.

- Runtime-configurable CA injection (no hardcoded certs), fully driven by Helm
- Zero-downtime CA rotation — update certificates without rebuilding images or restarting apps
- Automatic webhook TLS certificate generation via Helm hooks
- Custom organization CA support plus trust-manager bundle consolidation
- Namespace-scoped injection via labels; single image, production-ready with HA support

Technology Stack: Go · Helm · cert-manager trust-manager · Kubernetes 1.19+

[Source](https://github.com/kubetrust/kubetrust)

#### Enter Bash

I co-built **Enter Bash**, a hands-on DevOps & Cloud learning platform where learners spin up real, disposable lab containers, solve challenges, and earn XP and streaks on a leaderboard — practical practice instead of multiple-choice quizzes.

- Real lab environments per challenge (Docker / GitHub Actions runners), not simulations
- Structured challenges and learning paths across Linux, Kubernetes, Docker, Terraform, Ansible, and CI/CD
- Gamified progress: XP, daily streaks with multipliers, badges, and a global leaderboard
- GitHub / Google OAuth, user profiles, and admin tooling
- Open challenge-content repository so the community can contribute new scenarios

Technology Stack: SvelteKit (frontend) · Cloudflare Workers / Hono + D1 (backend) · Docker labs

[Source](https://github.com/enterbash/enter-bash-content) · [Live](https://enter-bash.fosskloud.workers.dev/)

#### IPA — Interview Panel Assistant

I built **IPA** (Interview Panel Assistant), a desktop app for interviewers that spins up shareable, live technical scenarios on a local Linux desktop using distrobox — so candidates get a real, reproducible environment instead of a shared screen-share.

- One-click ephemeral interview environments via distrobox (packages, files, and setup scripts defined as reusable scenarios)
- Shareable live terminal (ttyd) plus an optional Cloudflare tunnel so remote interviewers and candidates can join
- Session recording (asciinema) for later review
- Optional vCluster injection for Kubernetes interview scenarios, with kubeconfig wired straight into the shell
- Scenario import / export as tar.gz and IDE mode for richer debugging

Technology Stack: Go · Wails · Svelte / TypeScript · distrobox · Docker · ttyd · cloudflared · asciinema

*Private — not publicly available.*

### AI & Security

#### NeuroCAT

I built **NeuroCAT**, an AI-powered security hardening agent that turns CIS benchmark PDFs into audit scripts and scans remote Linux servers for compliance — so hardening stops being a slow, manual, error-prone chore.

- AI-generated audit scripts from CIS benchmarks using local Ollama (or OpenRouter) LLMs
- RAG over benchmarks (vector store) so scripts target the right controls precisely
- Secure SSH auditing of remote hosts (password or key based)
- JSON and HTML compliance reports for easy review
- Clean CLI workflow — ingest → generate → scan — runnable at scale

Technology Stack: Python 3.10+ · Ollama / OpenRouter · SSH · vector store

[Source](https://github.com/neur0cat/neurocat)

#### Kiro Gateway

I built **Kiro Gateway**, a proxy that lets any OpenAI- or Anthropic-compatible tool use Kiro's (AWS) free Claude models — so you can point Claude Code, Codex, Cursor, and friends at Claude without a paid API key.

- OpenAI-compatible API plus a native Anthropic `/v1/messages` endpoint
- Multi-account support with intelligent failover between accounts
- Extended thinking, vision, web search, tool calling, and full SSE streaming
- VPN / proxy support, smart token refresh, and retry logic for 403 / 429 / 5xx
- Works with Claude Code, OpenCode, Codex, Cursor, Cline, Roo Code, and more

Technology Stack: Python · FastAPI · multi-account token management

[Source](https://github.com/karthick-kk/kiro-gateway)

### Apps & Emulators

#### Nux Emulator

I contribute to **Nux**, a gaming-focused Android emulator for Linux with a polished GNOME-native UI — bringing near-native Android gaming to the desktop without proprietary layers.

- KVM hardware acceleration via crosvm for near-native CPU performance
- GPU passthrough with gfxstream (NVIDIA, AMD, and Intel)
- GTK4 + libadwaita interface, Wayland-first with full X11 support
- Android 16 (AOSP) on an x86_64 base
- Root support via Magisk / KernelSU / APatch, with microG by default (optional GApps)

Technology Stack: Rust · crosvm / KVM · gfxstream · GTK4 / libadwaita

[Source](https://github.com/nux-emulator/nux-emulator)

#### rDownloader

I built **rDownloader**, a cross-platform download manager (with a bonus AI video summarizer) that pairs a snappy Flutter UI with a high-performance Rust core via flutter_rust_bridge.

- Multi-platform desktop (Linux, Windows, macOS, Android) with system tray and window controls
- Rust-powered downloads with live progress, speed, and ETA streaming
- Clipboard detection that auto-detects and queues copied download links
- Built-in AI summarizer — paste a video URL and get an AI summary (configurable API)
- Automatic update checks

Technology Stack: Flutter / Dart · Rust (flutter_rust_bridge) · Riverpod · tray_manager

*Private — not publicly available.*

#### AGAM TV

I built **AGAM TV**, a cross-platform IPTV app with a Google TV-inspired interface for Android, Android TV, and Linux — tuned for Tamil and regional channels.

- Google TV-style grid with rounded channel icons and smooth animations
- Advanced player (media_kit on Linux / Windows, native on Android)
- Multiple sources: local M3U / JSON files and remote Gist playlists
- Favorites, categories (Tamil, Local, Movies), and fast search
- Cross-platform builds: Android APK and Linux AppImage, with a dark Material theme

Technology Stack: Flutter / Dart · media_kit · Provider · Dio / http · shared_preferences

[Source](https://github.com/karmedia/agamtv-releases)
