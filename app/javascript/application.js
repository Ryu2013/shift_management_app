// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
document.addEventListener("turbo:load", () => {
  const fake = document.getElementById("fake-month");
  const real = document.getElementById("real-month");
  const modal = document.getElementById("modal");
  const fakeClient = document.getElementById("fake-client");
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
