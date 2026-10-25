# Findings and recommendations

## Method

We selected one exact homepage URL for each of ten German welfare organisations. All ten were present in the October 2026 mobile root-page crawl. We extracted page-weight components from `summary`, CMS detections from `technologies` and accessibility audit results from `lighthouse`. Page-weight and Lighthouse resource measurements are separate observations and were not combined.

For accessibility details, we used the audit IDs referenced by the Lighthouse accessibility category and retained scores equal to zero. Manual, missing and non-applicable results were not counted as failures. The resulting dataset contains 20 unique site-audit pairs, 11 audit types and 7 affected sampled pages. Audit categories overlap and can describe the same underlying component.

## Recurring findings

| Audit | Sites | Organisations |
|---|---:|---|
| heading-order | 4 | Der Paritätische, Diakonie, DRK, Lebenshilfe |
| label-content-name-mismatch | 4 | Caritas, Der Paritätische, Diakonie, DRK |
| color-contrast | 2 | Johanniter, Tafel |
| link-name | 2 | Caritas, Der Paritätische |
| listitem | 2 | Diakonie, Johanniter |
| aria-required-children | 1 | Diakonie |
| aria-required-parent | 1 | Diakonie |
| dlitem | 1 | Tafel |
| frame-title | 1 | Caritas |
| select-name | 1 | DRK |
| target-size | 1 | Lebenshilfe |

The remaining three sampled pages do not appear in the failed-audits export. This is not evidence of full accessibility.

## Evidence examples

### DRK: service and course selection

At `2026-10-13T22:56:08.242Z`, audit `select-name` flagged `#tx-supplyfinder-selectbox` and `#tx-drkcoursesearch-angebote-selectbox` for missing accessible names. These controls relate to choosing services and courses. Recommendation: inspect their current rendering and connect each control to a meaningful visible label. Repeat testing with keyboard and screen-reader users.

Manual follow-up on October 25: the user did not locate either field on the current homepage, including mobile emulation and element-ID searches. Current presence and failure are unconfirmed. Do not describe this as fixed or as a verified current defect.

### Caritas: online counselling link

At `2026-10-15T04:40:49.028Z`, audit `label-content-name-mismatch` flagged the visible text `Online-Beratung` on `a.clips__clip[data-clip="tab-2"]`. The recorded `aria-label` was `Zu den Online-Beratungsangeboten der verbandlichen Caritas`. Recommendation: ensure the computed accessible name contains the visible label, and test voice control. Current-page verification is pending.

### Contrast

Tafel's October 14 audit listed 25 failing elements, including donation and cookie controls. White text against `#ef7d08` had reported contrast 2.76:1, below the 4.5:1 expectation for the specified normal text. Large text has a different applicable threshold. Johanniter had one flagged button, `Über die Johanniter`, with reported contrast 4:1 against an expected 4.5:1. Recommendations require current-page confirmation, colour adjustment and retesting.

## Page-weight priorities

| Organisation | Total MB | Component to investigate | Approximate share |
|---|---:|---|---:|
| DRK | 3.31 | Images: 2.43 MB | 73% |
| Lebenshilfe | 3.21 | Images: 2.43 MB | 76% |
| Johanniter | 3.14 | JavaScript: 2.10 MB | 67% |
| Caritas | 2.58 | Fonts: 0.94 MB | 36% |

MB means 1,000,000 bytes. Values come from the rounded export. Component size identifies priorities, not removable bytes. Inspect image sizing and formats, font variants and script necessity before proposing changes.

## Shared improvements

TYPO3 CMS was detected on seven sampled sites. Common guidance for site teams may be useful, but shared platform detection does not establish shared templates, maintainers or root causes. Prioritise verified recurring components over platform blame.

## Next steps

1. Confirm archived findings on current pages, recording viewport, timestamp and cookie/menu state.
2. Agree one improvement with a website team.
3. Repeat technical tests and assess the service journey with users of assistive technology.

No implementation, user-impact measurement, causal evaluation or representative sector-wide conclusions form part of this pilot.
