"""Reproduce descriptive figures locally. Does not connect to BigQuery."""
import csv
import json
from collections import defaultdict
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader((ROOT / 'data/site_metrics.csv').open()))
audits = json.loads((ROOT / 'data/failed_accessibility_audits.json').read_text())
assert len(rows) == 10 and len({r['page'] for r in rows}) == 10
assert all(r['date'] == '2026-10-01' for r in rows)
assert {r['page'] for r in audits} <= {r['page'] for r in rows}
assert len({(r['page'], r['audit_id']) for r in audits}) == len(audits)
FIG = ROOT / 'figures'
FIG.mkdir(exist_ok=True)
labels = [r['page'].removeprefix('https://').removeprefix('www.').rstrip('/') for r in rows]
fig, ax = plt.subplots(figsize=(11, 6))
left = [0.] * len(rows)
for key, title, colour in [('images_mb','Images','#25b9c3'),('fonts_mb','Fonts','#8b80b8'),('javascript_mb','JavaScript','#eea94a')]:
    vals = [float(r[key]) for r in rows]
    ax.barh(labels, vals, left=left, label=title, color=colour)
    left = [a+b for a,b in zip(left, vals)]
other = [round(float(r['total_mb'])-v, 2) for r,v in zip(rows,left)]
assert all(v >= 0 for v in other)
ax.barh(labels, other, left=left, label='Other', color='#bcc8d6')
ax.invert_yaxis()
ax.set_xlabel('Transferred MB (1 MB = 1,000,000 bytes), from summary')
ax.set_title('Mobile homepage weight: selected German welfare organisations')
ax.legend(ncol=4, loc='lower center', bbox_to_anchor=(.5,-.24), frameon=False)
fig.tight_layout()
fig.savefig(FIG / 'page_weight.png', dpi=180, bbox_inches='tight')
plt.close(fig)
by_audit = defaultdict(set)
for row in audits: by_audit[row['audit_id']].add(row['page'])
counts = sorted(((k,len(v)) for k,v in by_audit.items()), key=lambda p:(-p[1],p[0]))
fig, ax = plt.subplots(figsize=(11, 6))
ax.barh([k for k,v in counts], [v for k,v in counts], color='#082779')
ax.invert_yaxis()
ax.set_xticks(range(6))
ax.set_xlim(0,5)
ax.set_xlabel('Websites with a failed audit (out of 10); categories overlap')
ax.set_title('Failed automated accessibility audit types')
fig.tight_layout()
fig.savefig(FIG / 'accessibility_findings.png', dpi=180, bbox_inches='tight')
plt.close(fig)
print(f'{len(rows)} sites; {len(audits)} site-audit pairs; {len(by_audit)} audit types; {len({r["page"] for r in audits})} sites with failures')
