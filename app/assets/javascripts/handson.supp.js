// document.addEventListener('copy', function (e) {
//     console.log('copying');
// });
function setCharAt(str,index,chr) {
    if(index > str.length-1) return str;
    return str.substr(0,index) + chr + str.substr(index+1);
}

function setStringAt(str,index,strRep,indexInc) {
    if(index > str.length-1) return str;
    return str.substr(0,index) + strRep + str.substr(index+indexInc);
}

function isLetter(s)
{
  return s.match("^[a-zA-Z\(\)]+$");
}

// $(document).on('click','#reset-sheet',function(){
// 	$('#test-content').load('test.html');
// });

$(document).on('click','.open-file',function(){
	$('.open-file').hide();
	$('#container').fadeIn(1500);
	$('#sheet-01').show();
});

$(document).on('click','.toggle-sheet',function(){
	$('.sheet-hidden').hide();
	$('#' + $(this).attr('data-sheet')).show();
});

$(document).ready(function(){

	// $('.open-file').click(function(){
	// 	$('#container').show(2000);
	// 	$('.open-file').hide(2000);
	// });

	/* log the user in and then show them the instructions */

	$('#formula-form').submit(function(){

		var formData = $("#formula-input").val();
		console.log(formData);


		// var formData = $("#formula").serialize();



		// $.ajax({
		//     url : '/login/log_in', //Target URL for JSON file
		//     //contentType: 'application/json',
		//     method: 'POST',
		//     data: formData,
		//     //processData: false,
		//     //async : true,
		//     success : function(data){
		//     	//$('#messages').html(data);
		//     	//$(".form-control").val("");
		//     	if (data.length == 0){
		//     		$('#instructions').modal({backdrop: 'static', keyboard: false}, 'show');
		//     	}else{
		//     		alert(data);
		//     	}
		//         //console.log(data.length);
		//     },
		//     error : function(xhr, status){
		//         console.log(status);
		//     }
		// });
		return false;
	});

	//Adjust height of overlay to fill screen when page loads
   $("#fuzz").css("height", $(document).height());

   //When the link that triggers the message is clicked fade in overlay/msgbox
   $(".alert").click(function(){
      $("#fuzz").fadeIn();
      $('.msgbox').css("left", $("#login").position().left);
      $('.msgbox').css("top", $("#login").position().top);
      return false;
   });

   //When the message box is closed, fade out
   $(".close").click(function(){
      $("#fuzz").fadeOut();
      return false;
   });

});

//Adjust height of overlay to fill screen when browser gets resized
$(window).bind("resize", function(){
   $("#fuzz").css("height", $(window).height());
});