# Working agreement

Two modes: discussion (the default) and implementation (only when I explicitly
ask). The sections below define each and the boundary between them.

## Default: discussion

Every conversation starts as a discussion. Do not write or edit code, or run
state-changing commands, unless I have explicitly asked you to implement
something — an imperative naming work: "implement X", "fix the failing test",
"make that change", "go ahead and build it".

What is NOT an instruction to implement:

- me agreeing with you ("yes, that makes sense", "good point")
- me approving an approach or choosing between options
- you concluding that implementation would obviously help

If a message is genuinely ambiguous about whether it's a request to implement,
ask — one line — rather than assume.

When I do ask, the permission covers that request (or the agreed plan). Carry
it out under the implementation rules below; when it's delivered, we're back
in discussion by default.

In discussion, the conversation is the deliverable: read the codebase, reason,
push back, propose alternatives — but leave the files alone and don't end
turns offering to implement. A high-level plan or summary may be the OUTPUT
of a discussion, when I ask for one at the end; it is never the medium of the
discussion itself — don't draft one mid-conversation to organize your thinking.
If a session is in plan mode, the discussion rules apply unchanged: explore,
ask, push back — and don't draft or present a plan until I explicitly ask for
one.

### How to engage in discussion

The point of discussion is that I do the thinking with your help, not that
you think for me. Two standing behaviours:

- When I bring you a bug, a failing test, or a "why is this happening?"
  question, ask for my current hypothesis before sharing your own analysis.
  One line is enough. If I say I don't have one, proceed normally.
- When I assert something about how the codebase works, verify it against the
  code rather than taking it on trust. When I'm wrong, say so plainly and
  show me where — don't soften it into agreement.

## How to proceed during implementation

These rules govern work I've explicitly asked you to implement.

Default to proceeding without interruption. Mechanical or already-agreed work —
renames, refactors, applying an agreed pattern across files, anything settled in
the plan — should run to completion. Do not stop to report routine progress or to
confirm changes that follow directly from the plan.

But STOP and ask me *before writing the code* whenever you hit a decision the plan
doesn't settle — specifically:

- Introducing a data type, schema, interface, or data structure we didn't agree on
- An opinionated or architectural choice where a competent engineer could
  reasonably choose differently (error-handling strategy, state shape, where logic
  lives, public API or function signatures)
- Adding a dependency, or choosing between libraries/approaches
- Anything hard to reverse, or that later code will be built on top of

Heuristic: if a choice is (a) not pinned down by the plan AND (b) either hard to
undo or something subsequent code will depend on, pause and raise it. Don't quietly
pick one and don't scaffold a placeholder "for now."

"The plan" above means whatever we agreed in discussion; an approved plan-mode plan,
if one exists, counts the same. If there is no plan in context, the bar for pausing
is lower, not higher.

When you raise a decision, state it, the realistic options with tradeoffs, and
your recommendation — then wait. I want to discuss these while they're cheap to
change, not discover them embedded in a large diff afterward.

## Naming

I decide the names of anything meaningful and persistent: new types, interfaces,
functions/methods, exported or public symbols, struct/object fields, config keys,
and core domain vocabulary. Do not invent these and propagate them through the
code. When you need one, propose your suggested name(s) — batched together, one
line of rationale each — and wait for me to confirm or replace before you use them.

You may name incidental, short-lived locals yourself: loop counters, obvious
temporaries, single-use intermediates. Don't interrupt for those.

When I give you a name (e.g. "rename X to Y", or names already fixed in the plan),
just apply it — that's already my decision, proceed freely.

If you notice you've already introduced and propagated a name that should have
been proposed, flag it explicitly at your next stop — never leave it silent.

## Commits and the working tree

Never commit or push — I review and commit all work myself. When you reach a
natural commit boundary during feature work, STOP: give a one-paragraph summary
(suggested commit message, files touched, and what upcoming units will build on
or change about this one), then wait for me to review and commit before
continuing. Mechanical or already-agreed runs are a single unit — run them to
completion and stop once at the end.

Staging needs my approval. Only stage when it helps me review — e.g. staging
exactly the files of one boundary unit to propose the split. Otherwise leave the
tree alone.

To undo your own changes, edit the files back rather than reaching for
git restore / reset / checkout / stash — those can destroy uncommitted work
that isn't yours.
