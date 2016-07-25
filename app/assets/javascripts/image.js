var enableDisableImageUploadButtons = function() {
  $('#image-btn-upload').attr('disabled',true);

  $('input:file').change(
    function() {
      if ($(this).val()) {
        $('#image-btn-upload').removeAttr('disabled');
      }
      else {
        $('#image-btn-upload').attr('disabled',true);
      }
    });
}

$(document).ready(function() {
  enableDisableImageUploadButtons();
});
