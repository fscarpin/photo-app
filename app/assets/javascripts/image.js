$(document).ready(
  function(){
    $('#image-btn-upload').attr('disabled',true);
    $('#image-cancel-btn').attr('disabled', true)

    $('input:file').change(
      function(){
          if ($(this).val()){
              $('#image-btn-upload').removeAttr('disabled');
              $('#image-cancel-btn').removeAttr('disabled');
          }
          else {
              $('#image-btn-upload').attr('disabled',true);
              $('#image-cancel-btn').attr('disabled',true);
          }
      });
  });

