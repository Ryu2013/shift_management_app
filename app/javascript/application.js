// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
document.addEventListener("turbo:load", () => {
  const fake = document.getElementById("fake-month");
  const real = document.getElementById("real-month");
  const modal = document.getElementById("modal");
  const fakeClient = document.getElementById("fake-client");

  fakeClient.onclick = () => {
    modal.classList.toggle("open");
  }


  fake.onclick = () => real.showPicker();

  real.onchange = () => {
    const [y, m] = real.value.split("-");
    fake.textContent = `${m}月`;
  };
});
