#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  Claude Workflow Scaffold                                    ║
# ║  Sets up the full idea → build pipeline for any project     ║
# ╚══════════════════════════════════════════════════════════════╝

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}Claude Workflow Scaffold${NC}                                    ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Idea → Research → Plan → Build → Ship                      ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get project info
read -p "$(echo -e ${BOLD}Project name${NC} [my-app]: )" PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-my-app}

read -p "$(echo -e ${BOLD}One-line description${NC}: )" PROJECT_DESC

echo ""
echo -e "${BOLD}Tech stack:${NC}"
echo "  1) React + TypeScript (Vite)"
echo "  2) Next.js"
echo "  3) Python FastAPI"
echo "  4) Node.js Express"
echo "  5) Other / I'll decide later"
read -p "$(echo -e ${BOLD}Choice${NC} [5]: )" STACK_CHOICE
STACK_CHOICE=${STACK_CHOICE:-5}

case $STACK_CHOICE in
  1) STACK="React + TypeScript (Vite)" ;;
  2) STACK="Next.js" ;;
  3) STACK="Python FastAPI" ;;
  4) STACK="Node.js + Express" ;;
  *) STACK="TBD - decide during planning phase" ;;
esac

# Create project directory
echo ""
echo -e "${BLUE}Creating project structure...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# ─── CLAUDE.md ───────────────────────────────────────────────────
cat > CLAUDE.md << 'CLAUDEMD'
# Project: {{PROJECT_NAME}}

{{PROJECT_DESC}}

## Tech Stack
- {{STACK}}

## Architecture Decisions
<!-- Add decisions from your planning phase here -->
<!-- Example: "We chose Supabase over Firebase because..." -->

## Directory Structure
```
src/           # Application source code
docs/          # Planning docs, research, specs
  research.md  # Phase 1 output: exploration findings
  plan.md      # Phase 3 output: annotated implementation plan
  decisions.md # Architecture Decision Records
tests/         # Test files mirror src/ structure
```

## Coding Conventions
- Prefer small, focused functions (< 30 lines)
- Every file has a single responsibility
- Name files descriptively: `user-auth-handler.ts` not `handler.ts`
- Error handling: fail fast, log context, never swallow errors
- Comments explain WHY, not WHAT

## Common Commands
```bash
# Development
# npm run dev          # Start dev server
# npm test             # Run tests
# npm run lint         # Lint + format check

# Claude Code workflow
# /plan                # Enter plan mode (Shift+Tab x2)
# /compact             # Compress context when ~50% full
# /clear               # Fresh context between tasks
# /model               # Switch models (Sonnet for most, Opus for architecture)
```

## Workflow Rules
1. NEVER implement without a reviewed plan in docs/plan.md
2. ALWAYS commit before starting a new task
3. Run tests after every feature — if no tests exist, write them first
4. When context gets large, use "Document & Clear":
   - Write progress to docs/progress.md
   - /clear
   - Resume by reading docs/progress.md
5. For complex tasks, use subagents:
   - Frontend work → subagent 1
   - API work → subagent 2
   - Tests → subagent 3

## What Claude Gets Wrong (update this!)
<!-- This is the most valuable section. Every time Claude makes a mistake,
     document it here so it never happens again. Examples: -->
<!-- - "Don't use default exports, we use named exports everywhere" -->
<!-- - "Always check for null user before accessing user.email" -->
<!-- - "Our API returns { data, error } not { result, message }" -->
CLAUDEMD

# Replace placeholders
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" CLAUDE.md
  sed -i '' "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" CLAUDE.md
  sed -i '' "s|{{STACK}}|$STACK|g" CLAUDE.md
else
  sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" CLAUDE.md
  sed -i "s/{{PROJECT_DESC}}/$PROJECT_DESC/g" CLAUDE.md
  sed -i "s|{{STACK}}|$STACK|g" CLAUDE.md
fi

echo -e "  ${GREEN}✓${NC} CLAUDE.md"

# ─── Directory structure ──────────────────────────────────────────
mkdir -p src docs tests .claude/agents

echo -e "  ${GREEN}✓${NC} Project directories"

# ─── Planning templates ──────────────────────────────────────────
cat > docs/research.md << 'EOF'
# Research: [Feature/Project Name]

> Created: $(date +%Y-%m-%d)
> Status: 🔬 In Progress

## Problem Statement
<!-- What problem are we solving? For whom? -->

## User Interview Notes
<!-- Paste Claude's interview questions and your answers here -->
<!-- Start with: "Interview me about this idea. Ask probing questions
     about target users, core features, edge cases, and constraints." -->

## Competitive Landscape
<!-- What exists? What's missing? What's our angle? -->

## Technical Research
<!-- Relevant APIs, libraries, patterns, constraints -->

## Key Findings
<!-- Summarize what you learned. This feeds into plan.md -->

## Open Questions
<!-- What still needs answering before we can plan? -->
EOF

cat > docs/plan.md << 'EOF'
# Implementation Plan: [Feature/Project Name]

> Created: $(date +%Y-%m-%d)
> Status: 📝 Draft | 🔄 Annotating | ✅ Approved
> Annotation cycles: 0

## Overview
<!-- 2-3 sentence summary of what we're building -->

## Architecture
<!-- High-level architecture. Include a simple diagram if helpful -->

## Implementation Steps

### Step 1: [Name]
**Files:** `src/...`
**What:** 
**Why:** 
<!-- YOUR ANNOTATION: -->

### Step 2: [Name]
**Files:** `src/...`
**What:** 
**Why:** 
<!-- YOUR ANNOTATION: -->

### Step 3: [Name]
**Files:** `src/...`
**What:** 
**Why:** 
<!-- YOUR ANNOTATION: -->

## Trade-offs & Decisions
| Decision | Option A | Option B | Chosen | Why |
|----------|----------|----------|--------|-----|
|          |          |          |        |     |

## Testing Strategy
<!-- What tests? Unit, integration, E2E? What's the minimum viable test suite? -->

## Rollback Plan
<!-- How do we undo this if it goes wrong? -->

---
## Annotation Log
<!-- Track your annotation cycles here -->
<!-- Cycle 1: [date] - Added notes on auth flow, flagged missing error handling -->
<!-- Cycle 2: [date] - Approved steps 1-3, rewrote step 4 -->
EOF

cat > docs/decisions.md << 'EOF'
# Architecture Decision Records

## ADR-001: [Title]
- **Date:** 
- **Status:** Proposed | Accepted | Deprecated
- **Context:** What is the issue?
- **Decision:** What did we decide?
- **Consequences:** What are the trade-offs?

---
<!-- Copy the template above for each new decision -->
EOF

cat > docs/progress.md << 'EOF'
# Progress Log

> Use this for the "Document & Clear" pattern.
> Before running /clear, dump your current state here.
> After /clear, tell Claude: "Read docs/progress.md and continue."

## Current State
<!-- What's done? What's in progress? What's next? -->

## Last Session
<!-- Date, what was accomplished, any blockers -->
EOF

echo -e "  ${GREEN}✓${NC} Planning templates (research.md, plan.md, decisions.md, progress.md)"

# ─── Claude Code hooks ───────────────────────────────────────────
cat > .claude/settings.json << 'HOOKS'
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "write|edit|create",
        "command": "echo '✅ File changed — remember to test'"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "write|edit",
        "command": "bash -c 'FILE=\"$CLAUDE_FILE\"; if [[ \"$FILE\" == *\".env\"* ]] || [[ \"$FILE\" == *\"secret\"* ]]; then echo \"🚫 BLOCKED: Cannot edit sensitive files\" && exit 1; fi'"
      }
    ],
    "Notification": [
      {
        "command": "echo '🔔 Claude finished a task' && (which osascript > /dev/null 2>&1 && osascript -e 'display notification \"Claude Code finished a task\" with title \"Claude\"' || true)"
      }
    ]
  },
  "permissions": {
    "allow": [
      "Read(**)",
      "Write(src/**)",
      "Write(tests/**)",
      "Write(docs/**)"
    ],
    "deny": [
      "Write(.env*)",
      "Write(**/secret*)"
    ]
  }
}
HOOKS

echo -e "  ${GREEN}✓${NC} Claude Code hooks (auto-format, file protection, notifications)"

# ─── Custom subagent: code reviewer ──────────────────────────────
cat > .claude/agents/reviewer.md << 'EOF'
# Code Reviewer Agent

You are a senior code reviewer. Your job is to review code changes for:

1. **Correctness** — Does it do what it should?
2. **Edge cases** — What could break?
3. **Simplicity** — Can it be simpler?
4. **Naming** — Are names clear and consistent?
5. **Tests** — Are there tests? Are they meaningful?

Be concise. Flag issues by severity:
- 🔴 MUST FIX — Bugs, security issues, data loss risks
- 🟡 SHOULD FIX — Code smells, unclear naming, missing tests
- 🟢 NIT — Style preferences, minor improvements

Don't rewrite code unless asked. Just identify issues.
EOF

cat > .claude/agents/planner.md << 'EOF'
# Planning Agent

You are a technical planning specialist. Your job is to:

1. Read the existing codebase thoroughly before proposing changes
2. Create detailed implementation plans with file paths and code snippets
3. Identify risks, edge cases, and dependencies
4. Propose a testing strategy for each step

Always output plans in the format defined in docs/plan.md.
Never implement code — only plan. If asked to implement, refuse and
remind the user to switch to the main agent for implementation.
EOF

echo -e "  ${GREEN}✓${NC} Custom subagents (reviewer, planner)"

# ─── MCP config template ─────────────────────────────────────────
cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "_comment": "Uncomment and configure the MCP servers you need",

    "_github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-token>" }
    },

    "_filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./src", "./docs"]
    },

    "_playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-playwright"]
    }
  }
}
EOF

echo -e "  ${GREEN}✓${NC} MCP config template (.mcp.json)"

# ─── Git setup ────────────────────────────────────────────────────
git init -q
cat > .gitignore << 'EOF'
node_modules/
.env
.env.*
dist/
build/
__pycache__/
*.pyc
.DS_Store
.claude/settings.local.json
EOF

git add -A
git commit -q -m "scaffold: initialize project with Claude workflow infrastructure"

echo -e "  ${GREEN}✓${NC} Git initialized with first commit"

# ─── Workflow cheatsheet ──────────────────────────────────────────
cat > WORKFLOW.md << 'WORKFLOW'
# Workflow Cheatsheet

## The 5-Phase Pipeline

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  1. IDEATE   │───▶│ 2. PROTOTYPE│───▶│   3. PLAN   │───▶│  4. BUILD   │───▶│  5. VERIFY  │
│ Claude Chat  │    │  Artifacts  │    │ Claude Code │    │ Claude Code │    │ Hooks + CI  │
│              │    │             │    │  Plan Mode  │    │ Normal Mode │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Phase 1: Ideate (Claude Desktop / claude.ai)
```
Prompt: "Interview me about [idea]. Ask probing questions about 
target users, core features, edge cases, and constraints."

Then: "Based on our discussion, write an architecture document 
covering tech stack, data model, and key components. Think hard."
```
→ Save output to `docs/research.md`

### Phase 2: Prototype (Claude Desktop Artifacts)
```
Prompt: "Build an interactive prototype of [the main screen]. 
Include [key interactions]. Use realistic placeholder data."

Iterate: "Make the sidebar collapsible" / "Add a loading state" / 
"Switch to dark mode" / [paste screenshot] "Match this design"
```
→ Screenshot the final prototype for reference

### Phase 3: Plan (Claude Code — Plan Mode)
```bash
# Enter plan mode
> Shift+Tab twice (or /plan)

# Step 1: Explore
> "Read the codebase. Understand how [relevant area] works. 
   Write findings to docs/research.md"

# Step 2: Plan  
> "Create a detailed plan in docs/plan.md for [feature]. 
   Include file paths, code snippets, and trade-offs."

# Step 3: Annotate (REPEAT 1-6 TIMES)
> Open docs/plan.md in your editor
> Add inline comments: <!-- YOUR ANNOTATION: not optional -->  
> "I added annotations to the plan. Address all notes. Don't implement."

# Step 4: Approve
> "The plan is approved. Implement it all."
```

### Phase 4: Build (Claude Code — Normal Mode)
```bash
# Switch to normal mode
> Shift+Tab once

# For straightforward implementation:
> "Implement the plan from docs/plan.md"

# For complex work, use subagents:
> "Spawn a subagent to handle the frontend components in the plan.
   Spawn another for the API endpoints. I'll handle tests."

# Context management:
> /compact          # At ~50% context, compress
> /clear            # Between unrelated tasks (save to docs/progress.md first!)
> /model opus       # Switch to Opus for hard architecture decisions
> /model sonnet     # Switch back for standard implementation
```

### Phase 5: Verify
```bash
# Run tests
> "Run all tests and fix any failures"

# Code review via subagent
> "Use the reviewer agent to review the changes in this PR"

# Browser testing (if Playwright MCP is configured)
> "Open the app in a browser and test the [feature] flow end-to-end"

# Ship it
> /commit-push-pr
```

## Emergency Commands
```bash
git stash              # Quick save
git reset --hard HEAD  # Nuclear revert to last commit
/clear                 # Fresh context
/compact               # Compress context without losing it
```

## Model Selection Guide
| Task                        | Model   | Why                           |
|-----------------------------|---------|-------------------------------|
| Standard implementation     | Sonnet  | Fast, cheap, 80% of tasks    |
| Architecture decisions      | Opus    | Better reasoning              |
| Large refactors (10K+ LOC)  | Opus    | Handles complexity better     |
| Writing tests               | Sonnet  | Pattern-matching task         |
| Code review                 | Sonnet  | Sufficient for review         |
| Multi-agent coordination    | Opus    | Better orchestration          |

## Extended Thinking Keywords
| Keyword      | Thinking Tokens | Use For                        |
|--------------|-----------------|--------------------------------|
| "think"      | ~4K             | Simple decisions               |
| "think hard" | ~10K            | Architecture, trade-offs       |
| "ultrathink" | ~32K            | Complex system design          |
WORKFLOW

echo -e "  ${GREEN}✓${NC} WORKFLOW.md cheatsheet"

# ─── Done! ────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}Scaffold complete!${NC}                                          ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Your project is at:${NC} $(pwd)"
echo ""
echo -e "  ${BOLD}What was created:${NC}"
echo -e "  ${CYAN}CLAUDE.md${NC}              → Project memory (Claude Code reads this first)"
echo -e "  ${CYAN}WORKFLOW.md${NC}            → Quick-reference cheatsheet for all 5 phases"
echo -e "  ${CYAN}docs/research.md${NC}       → Template for Phase 1 research"
echo -e "  ${CYAN}docs/plan.md${NC}           → Template for Phase 3 annotated planning"
echo -e "  ${CYAN}docs/decisions.md${NC}      → Architecture Decision Records"
echo -e "  ${CYAN}docs/progress.md${NC}       → Document & Clear pattern scratchpad"
echo -e "  ${CYAN}.claude/settings.json${NC}  → Hooks (file protection, notifications)"
echo -e "  ${CYAN}.claude/agents/${NC}        → Custom subagents (reviewer, planner)"
echo -e "  ${CYAN}.mcp.json${NC}              → MCP server config (GitHub, Playwright, etc.)"
echo ""
echo -e "  ${BOLD}${YELLOW}Next steps:${NC}"
echo -e "  1. ${BOLD}cd $PROJECT_NAME${NC}"
echo -e "  2. Open in Claude Desktop → Start Phase 1 (Ideate)"
echo -e "  3. When ready to build → ${BOLD}claude${NC} (launches Claude Code in this dir)"
echo ""
echo -e "  ${BOLD}Tip:${NC} Open WORKFLOW.md for the full phase-by-phase playbook."
echo ""
