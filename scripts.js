// Einfache clientseitige Filterung der Forschungstabelle
document.addEventListener('DOMContentLoaded', function () {
  const input = document.getElementById('table-filter');
  const table = document.getElementById('research-table');
  const tbody = table.tBodies[0];
  if (!input || !tbody) return;

  input.addEventListener('input', function () {
    const q = input.value.trim().toLowerCase();
    const rows = Array.from(tbody.rows);
    if (!q) {
      rows.forEach(r => r.style.display = '');
      return;
    }
    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      row.style.display = text.includes(q) ? '' : 'none';
    });
  });
});
