# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **Neural-Vault**, a personal Obsidian knowledge vault of study notes — not a software project. There is no build, lint, or test step. Work consists of reading, writing, and reorganizing Markdown notes. The audience is a single student studying CS/ML/maths topics.

## Structure & conventions

Top-level folders are numbered domains: `01_Dev`, `02_Devops`, `03_Ai_ml`, `04_DSA`, `05_OS & Systems`, `06_Maths`, `07_Hardware & IoT`, `08_OC` (open-source / competitions), `09_Ai_Agents`. Within each, subfolders and many note files use a `NN_Topic_Name` numeric prefix to impose reading order. Preserve this prefixing when adding files so ordering stays intact.

Cross-cutting folder conventions:
- `00_Index/` holds dashboards/entry points; many domain folders contain a README-style note acting as a folder index (see `04_DSA`).
- `_archive/`, `_Dashboards/`, `_templates/`, `_utilities/` (underscore prefix) are meta/support folders, not study content. `_templates` and `_utilities` are gitignored.
- `_Dashboards/` contains standalone `.html` files (interactive visualizations) alongside the notes.

## Note format

Notes follow templates in `_templates/` (`_Theory.md`, `_DSA.md`, `_Framework.md`). When the Templater plugin is used, new notes get YAML frontmatter (`title`, `tags`, `created`, `updated`) plus emoji-headed sections. However, many existing notes (e.g. `06_Maths/.../01_Probability_Fundamentals.md`) are plain prose with `# Title`, a `Source:` line, and `##` sections — match the style of the surrounding notes in whichever folder you edit rather than forcing the template.

Common note elements to keep consistent: link to the source video/article near the top, and include runnable Python snippets in fenced code blocks for ML/maths topics. Note that cross-note navigation is done mainly through folder README index notes and `00_Index/Dashboard.md` rather than dense `[[wiki-links]]` — most `[[...]]` occurrences in notes are either bash `[[ condition ]]` inside code blocks or `![[...]]` embeds of images and `.excalidraw.md` drawings.

## Obsidian environment

This vault is opened in Obsidian. Relevant active plugins: `obsidian-git` (auto-commits — hence terse, sometimes auto-generated commit messages), `templater-obsidian`, `obsidian-excalidraw-plugin` (`.excalidraw.md` drawing files), `obsidian-icon-folder`, `code-styler`. Do not hand-edit `.obsidian/` config or `.excalidraw` files unless asked; `.obsidian/workspace.json` changes are local UI state and usually shouldn't be committed.

## Working in this repo

- Commit messages are short and topic-led (e.g. `feat: Maths Stats,Prob v1`, `Maths+DSA`, `DSA Notes two pointer`). Match that brevity; group by the domain(s) touched.
- Folder names contain spaces and `&` (e.g. `05_OS & Systems`, `04_DSA/01_Core Java`) — quote paths in shell commands.
- When asked to "add notes" on a topic, place them in the correct numbered domain folder, apply the next available `NN_` prefix, and follow the prose/section style already present there.
