function init_char_max() {
  const input_event = new Event('input');

  var fields_limited = document.querySelectorAll('textarea.char-max');
  [].forEach.call(fields_limited, (e) => {
    e.addEventListener('input', function (j) {
      counted_field = j.srcElement;
      max_chars = parseInt(counted_field.dataset.cmsCharmax);
      cur_length = counted_field.value.length;
      counter_el = document.querySelector('#' + counted_field.id + 'CharCount');

      if (counter_el) {
        counter_el.textContent = cur_length + ' / ' + max_chars + ' characters';
      }

      if (cur_length > max_chars) {
        counter_el.classList.replace('bg-success', 'bg-danger');
        counted_field.setCustomValidity('Too many characters');
      }
      else {
        counter_el.classList.replace('bg-danger', 'bg-success');
        counted_field.setCustomValidity('');
      }
    }, false);

    e.dispatchEvent(input_event);

  });
}

function init_word_max() {
  const input_event = new Event('input');

  var fields_limited = document.querySelectorAll('textarea.word-max');
  [].forEach.call(fields_limited, (e) => {
    e.addEventListener('input', function (j) {
      counted_field = j.srcElement;
      max_words = parseInt(counted_field.dataset.cmsWordmax);
      content = counted_field.value;
      content = content.replace(/-/g, "");
      // if (content.match(/\w+\W+/g))
      if (content.match(/\b\S+\b/g)) {
        // cur_length = content.match(/\w+\W+/g).length;
        cur_length = content.match(/\b\S+\b/g).length;
      }
      else {
        cur_length = 0;
      }

      counter_el = document.querySelector('#' + counted_field.id + 'WordCount');

      if (counter_el) {
        counter_el.textContent = cur_length + ' / ' + max_words + ' words';
      }

      if (cur_length > max_words) {
        counter_el.classList.replace('bg-success', 'bg-danger');
        counted_field.setCustomValidity('Too many words');
      }
      else {
        counter_el.classList.replace('bg-danger', 'bg-success');
        counted_field.setCustomValidity('');
      }

    }, false);

    e.dispatchEvent(input_event);

  });
}

function init_listeners(e) {
  init_char_max();
  init_word_max();
}

document.addEventListener('DOMContentLoaded', (event) => {
  init_listeners(event);
});
document.addEventListener('DOMContentLoaded', function () {
  var carouselEl = document.getElementById('IG27-carousel');
  if (!carouselEl) {
    return;
  }

  var firstItem = carouselEl.querySelector('.carousel-item.dim-animate');
  if (firstItem) {
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        firstItem.classList.remove('dim-animate');
      });
    });
  }

  carouselEl.addEventListener('slide.bs.carousel', function () {
    carouselEl.classList.add('initialized');
  }, { once: true });
});
