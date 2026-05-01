---
name: sos:assistant
description: Guided SOS front door for users who want help choosing and using SOS workflows.
disable-model-invocation: true
---

# /sos:assistant

Run `/sos:assistant` when the user wants to interact with SOS conversationally instead of choosing a specific command.

Read these first:

1. `.claude/sos/ASSISTANT.md`
2. `.claude/sos/COMMANDS.md`
3. `.claude/PM.md`
4. `.claude/STONE.md`
5. `.claude/WORKFLOW.md`

If the user has not stated a concrete goal, ask what they are trying to do with SOS right now.

Route the conversation to the correct SOS workflow. If the platform cannot invoke the slash command directly, follow that command's protocol in-place and say which protocol is being used.

Do not bypass human gates. Assistant may explain, route, and propose; concrete writes still follow the target command's approval rules.
