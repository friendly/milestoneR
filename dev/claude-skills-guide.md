# Claude Code Skills Guide

## Global Skills for R Package Development

### Where to Place Skills for Global Access

For global access across all your R packages and projects, place your skills in:

**`~/.claude/skills/`**

On Windows, this translates to: **`C:\Users\friendly\.claude\skills\`**

Each skill goes in its own subdirectory with a `SKILL.md` file:

```
~/.claude/skills/
├── r-package-check/
│   └── SKILL.md
├── pkgdown-build/
│   └── SKILL.md
├── r-documentation/
│   └── SKILL.md
└── run-r-tests/
    └── SKILL.md
```

### How Claude Code Discovers and Loads Skills

Claude Code uses a **scope hierarchy** for skill discovery:

**Precedence order (highest to lowest):**
1. **Enterprise/Managed** - System-wide, deployed by administrators
2. **Personal (User)** - `~/.claude/skills/` - Available across all projects
3. **Project** - `.claude/skills/` - Specific to individual repositories
4. **Plugin** - Bundled with plugins

**If two skills have the same name, the higher scope wins.** For example, if you have a skill in both `~/.claude/skills/` and `.claude/skills/`, the personal version takes precedence.

**Discovery Process:**
1. At startup, Claude loads only the **name and description** of each available skill (keeps startup fast)
2. When your request matches a skill's description, Claude asks for permission to use it
3. The full `SKILL.md` is loaded only when you approve

### Configuration

**No special configuration is needed.** Skills in `~/.claude/skills/` are automatically discovered and loaded at startup.

However, you can optionally configure permissions in your settings:

**Location:** `~/.claude/settings.json`

Example:
```json
{
  "permissions": {
    "allow": [
      "Bash(Rscript:*)",
      "Bash(R:*)"
    ]
  }
}
```

**Project-level overrides:** If a project needs different settings than global, use `.claude/skills.json` or `.claude/settings.local.json` (not committed to git).

### Best Practices for Organizing Global vs Project-Specific Skills

**Use Global Skills (`~/.claude/skills/`) for:**
- R-specific utilities you use across all packages:
  - Running R tests (`devtools::test()`)
  - Linting (`lintr::lint_package()`)
  - Documentation generation (`devtools::document()`)
  - Package checking (`devtools::check()`)
  - pkgdown site building
- Common workflows that apply to multiple projects
- Reusable standards or patterns (e.g., commit message formatting, code review guidelines)
- Your configured custom skills like: `/init`, `/pr-comments`, `/statusline`, `/review`, `/security-review`

**Use Project Skills (`.claude/skills/`) for:**
- Package-specific workflows (e.g., custom build commands, specialized test suites)
- Team-shared standards committed to git
- Skills that should be available to all contributors on that project
- Workflows specific to that repository's structure or conventions

### Example Global Skill Structure for R Packages

```
C:\Users\friendly\.claude\skills\
├── r-package-check/
│   ├── SKILL.md
│   └── reference.md
├── pkgdown-build/
│   └── SKILL.md
├── r-documentation/
│   └── SKILL.md
├── run-r-tests/
│   └── SKILL.md
├── commit-messages/
│   └── SKILL.md
└── code-review/
    └── SKILL.md
```

### Moving Existing Skills to Global

If you have project-specific skills that you want to use globally:

```bash
# Create the global skills directory if it doesn't exist
mkdir -p ~/.claude/skills

# For each skill you want to make global:
cp -r .claude/skills/my-skill ~/.claude/skills/

# You can then remove from project .claude/skills/ if desired
```

### Key Benefits of Global Organization

- Access skills across all R packages without duplication
- Consistent workflows across your entire development environment
- Easy to maintain one version of each skill
- Skills are available immediately when you start Claude Code in any project
- Your configured skills are available for all package work

## Windows Home Directory

On your Windows machine:
- `~/` refers to: **`C:\Users\friendly\`**
- `.claude/` directory: **`C:\Users\friendly\.claude\`**
- Global skills location: **`C:\Users\friendly\.claude\skills\`**
- Global settings: **`C:\Users\friendly\.claude\settings.json\`**

You can create the global skills directory with:
```bash
mkdir -p ~/.claude/skills
```

Or on Windows PowerShell/CMD:
```cmd
mkdir C:\Users\friendly\.claude\skills
```
