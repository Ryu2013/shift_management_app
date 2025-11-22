// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
document.addEventListener("turbo:load", () => {
  const fake = document.getElementById("fake-month");
  const real = document.getElementById("real-month");

  // シフト一覧ページの月選択カスタマイズ処理
  if (fake && real) {
  fake.onclick = () => real.showPicker();

  real.onchange = () => {
    const [y, m] = real.value.split("-");
    fake.textContent = `${m}月`;
    real.form.requestSubmit();
  };
  };
  
});


// シフト個別変更フォームの表示処理
// turbo:frame-loadで発火させることで、turbo frame内の要素に対応
document.addEventListener("turbo:frame-load", () => {
const btn = document.getElementById("shift-form-btn");
const form = document.getElementById("shift-form");
const deleteBtn = document.getElementById("shift-form-delete");
if (btn && form && deleteBtn) {
btn.addEventListener("click", () => {
  form.classList.toggle("open");
  deleteBtn.classList.toggle("open");
});
}
});

// ハンバーガーメニューの表示処理
document.addEventListener("turbo:load", () => {
const hamburger = document.getElementById("hamburger");
const pcNav = document.querySelector(".menus");
if (hamburger && pcNav) {
hamburger.addEventListener("click", () => {
  pcNav.classList.toggle("open-menus");
});
}
});

//出勤状況確認ページの日付選択の見た目が気に入らないのでカスタマイズ
// 日付選択用のカレンダーピッカー表示
document.addEventListener("turbo:load", () => {
const fakeDate = document.getElementById("fake-date");
const realDate = document.getElementById("real-date");
if (fakeDate && realDate) {
  fakeDate.onclick = () => realDate.showPicker();

  realDate.onchange = () => {
    const [y, m, d] = realDate.value.split("-");
    fakeDate.textContent = `${y}年${m}月${d}日`;
    realDate.form.requestSubmit();
  };
}
});


//home用インターセクト時にクラス付与
document.addEventListener("turbo:load", () => {
  const targets = document.querySelectorAll('.fadein'); 

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {          
        entry.target.classList.add('visible'); 
        observer.unobserve(entry.target);      
      }
    });
  }, { threshold: 0.3 }); // 10%見えたら反応

  targets.forEach(target => observer.observe(target)); 
});


// app/javascript/custom/home_animation.js
// (application.jsなどでimportしてください)

const setupAnimations = () => {
  // 監視対象の要素を取得
  const targets = document.querySelectorAll('.scroll-trigger');

  // オプション設定
  const options = {
    root: null, // ビューポート
    rootMargin: '0px 0px -15% 0px', // 画面の下15%に入ったら発火（少し早めに）
    threshold: 0
  };

  const observer = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // クラス付与でCSSトランジションを開始
        entry.target.classList.add('is-visible');
        // 一度表示したら監視をやめる（パフォーマンス考慮）
        observer.unobserve(entry.target);
      }
    });
  }, options);

  targets.forEach(target => {
    observer.observe(target);
  });
};

// Turbo Driveのロード時と、通常のロード時の両方に対応
document.addEventListener("turbo:load", setupAnimations);
document.addEventListener("DOMContentLoaded", setupAnimations);