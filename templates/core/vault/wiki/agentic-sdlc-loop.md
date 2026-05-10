---
sos-file: base-knowledge
sos-version: 0.2.0
sos-schema: 1
sos-origin: packaged
sos-managed: true
type: base-knowledge
scope: sos
status: active
tags:
  - agentic-sdlc
  - delivery-loop
  - ai-workflow
---

# Agentic SDLC Loop

## Purpose

This note explains the default SolutionOS operating loop for AI-assisted work.

The loop is not ceremony. It is a lightweight structure that helps humans and AI understand where the work is, what is happening, and what done means.

## The Mindset Shift

The old way is:

```text
I hold the project in my head and use AI when I need help.
```

The better operating model is:

```text
The project has an operating structure, and AI works inside that structure with me.
```

This prevents work from living only inside one person's head. AI works better when context, goals, proof, and gates are visible.

## The Seven-Step Loop

```text
Inspect -> Plan -> Prove -> Implement -> Verify -> Review -> Capture
```

## What Each Step Means

**Inspect**

Understand what we are doing, the current state, constraints, risks, relevant context, existing conventions, and what must not be disturbed.

**Plan**

Choose the route before acting. Decide the approach, likely work areas, order of work, human gates, and what should stay out of scope.

**Prove**

Define what success looks like before the main change. This could be a failing test, acceptance check, expected output, example, prototype, spike, screenshot expectation, manual checklist, or written success criteria.

**Implement**

Make the scoped change inside the agreed route. This is where the actual build or change happens, guided by the previous steps.

**Verify**

Check reality. Run tests, inspect outputs, open the UI, review logs, compare against success criteria, or otherwise prove the work behaves as intended.

**Review**

Get a second view. Use human review, PR review, another AI pass, CI feedback, security review, architecture review, or domain review depending on the risk.

**Capture**

Keep the lesson. Record decisions, gotchas, useful commands, review lessons, tool lessons, assumptions, and next actions so future work does not start from zero.

## What Each Step Prevents

- Inspect prevents acting on the wrong problem.
- Plan prevents uncontrolled wandering.
- Prove prevents vague success.
- Implement prevents endless planning without delivery.
- Verify prevents confidence without evidence.
- Review catches what your own head made invisible.
- Capture stops future-you from paying for the same lesson again.

## How This Maps To AI-Assisted Software Work

Coding is not the whole project, just like packing is not the whole trip. Implementation is only one workstream inside delivery.

Spec-driven work belongs mainly in Plan and Prove. It means making intended behavior visible before implementation starts. A spec can be short: acceptance criteria, examples, expected inputs and outputs, UI behavior notes, constraints, non-goals, or test cases.

In SOS terms:

- Plan decides the route.
- The spec states what should be true.
- Prove decides what evidence would make us confident the spec has been met.
- Verify checks the real result against that evidence.

Proof does not always mean automated tests. It means deciding what evidence would make us confident. Verification is not the same as feeling confident. Evidence matters.

## Human Gates

Human gates matter around planning, risky changes, external communication, PRs, deployment, deletion, and structural changes.

Projects may adapt the loop, but should not skip verification, review, or capture by default.

## Friendly Analogy For Beginners

The whole flow is like shaping a surfboard for a real rider and real waves.

**Inspect**

Look at the blank board, the wave conditions, and the rider. Who is this for? What waves will it face? What problem are we solving?

**Plan**

Sketch the board shape, dimensions, rails, rocker, and fin setup. Choose the route before cutting foam.

**Prove**

Try a cheap foam prototype, template, or small test piece before shaping the real board. Get cheap confidence before expensive work.

**Implement**

Shape the real board. Do the actual work, but inside the chosen shape.

**Verify**

Take the board into the water and see how it actually rides. Confidence is not verification; evidence is verification.

**Review**

The rider, coach, and shaper watch the footage and critique the result. Review catches what your own head made invisible.

**Capture**

Write down what worked so the next board starts smarter. If the lesson is not captured, future-you pays for it again.

## Quick Reference

```text
Inspect   What is true now?
Plan      What route are we taking?
Prove     What evidence would show success?
Implement Make the scoped change.
Verify    Check reality against the evidence.
Review    Get a second view.
Capture   Keep the lesson.
```
