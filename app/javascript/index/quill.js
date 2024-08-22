function initializeQuill(initialContent) {
  const quill = new Quill('#editor-container', {
    theme: 'snow',
    modules: {
      toolbar: [
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
        ['bold', 'italic', 'underline', 'strike'],
        ['blockquote', 'code-block'],

        [{ 'list': 'ordered' }, { 'list': 'bullet' }],
        [{ 'script': 'sub' }, { 'script': 'super' }],
        [{ 'indent': '-1' }, { 'indent': '+1' }],
        [{ 'direction': 'rtl' }],

        [{ 'size': ['small', false, 'large', 'huge'] }],
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],

        [{ 'color': [] }, { 'background': [] }],
        [{ 'font': [] }],
        [{ 'align': [] }],

        ['clean'],

        ['link', 'image', 'video']
      ]
    }
  });

  const hiddenBodyField = document.getElementById('hidden-body-field');
  if (initialContent) {
    quill.root.innerHTML = initialContent;
    console.log(initialContent);
  }

  quill.on('text-change', function () {
    hiddenBodyField.value = quill.root.innerHTML;
    console.log('Textarea Value:', hiddenBodyField.value);
  });
}

document.addEventListener('turbo:load', function () {
  const initialContent = $('#hidden-body-field').val();
  initializeQuill(initialContent);
});
