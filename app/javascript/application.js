// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
document.addEventListener("turbo:load", () => {
  const fake = document.getElementById("fake-month");
  const real = document.getElementById("real-month");
  const modal = document.getElementById("modal");
  const fakeClient = document.getElementById("open-modal");
  const closeModal = document.getElementById("close-modal");

  fakeClient.onclick = () => {
    modal.classList.toggle("open");
  }

  closeModal.onclick = () => {
    modal.classList.remove("open");
  }


  fake.onclick = () => real.showPicker();

  real.onchange = () => {
    const [y, m] = real.value.split("-");
    fake.textContent = `${m}月`;
  };
});
//httpもしくはturboDriveで発火確認。blordcast,turboFrameでは発火していない。
//すべてのページでwindow.Turbo.visitを確認したが、一応http処理も残す。
document.addEventListener("turbo:load", () => {
const form = document.getElementById("filters-form");
console.log("発火");
if (!form) return;
form.addEventListener("submit", (e) => {
e.preventDefault();
const teamId = form.querySelector('[name="team_id"]').value;
const clientId = form.querySelector('[name="client_id"]').value;
const date = form.querySelector('#real-month')?.value || "";
const q = date ? `?date=${encodeURIComponent(date)}` : "";
if (window.Turbo?.visit) {
Turbo.visit(`/teams/${teamId}/clients/${clientId}/shifts${q}`);
} else {
window.location.href = `/teams/${teamId}/clients/${clientId}/shifts${q}`;
}
});
});
