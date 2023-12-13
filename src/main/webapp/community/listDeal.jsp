<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>택시비 딜 상세조회</title>
  
  <!-- templates 설정 -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
  <link rel="stylesheet" type="text/css" href="/templates/styles/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/templates/fonts/bootstrap-icons.css">
  <link rel="stylesheet" type="text/css" href="/templates/styles/style.css">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <!-- templates 설정 끝 -->
  
  <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
  
  <script>
  
  $(function (){
      $(".reqbt").on("click", function (){
          // 현재 클릭한 버튼의 부모 행(tr)을 찾아서
          var row = $(this).closest('div.card');

          // 부모 행에서 배차 번호와 제시 금액을 가져오기
          var callNo = row.find('.callNo').text().trim();
          var passengerOffer = row.find('.passengerOffer').text().trim();
          
          if (${user.dealCode}) {
              alert("이미 다른 딜 배차에 참여 중 입니다.");
          } else if (!${user.dealCode}){
            $('#notification-bar-5').removeClass('notification-bar glass-effect detached rounded-s shadow-l')
              .addClass('notification-bar glass-effect detached rounded-s shadow-l fade show');
            $(".offerbt").off("click").on("click", function () {
              let driverOffer = parseFloat($("#driverOffer").val());
              console.log("offerbt");
              console.log(callNo);
              console.log(passengerOffer);
              console.log(driverOffer);
              alert("offerbt");
              
              if (driverOffer > passengerOffer) {
                    $('#toast-top-2').removeClass('toast toast-bar toast-top rounded-l bg-red-dark shadow-bg shadow-bg-s')
                          .addClass('toast toast-bar toast-top rounded-l bg-red-dark shadow-bg shadow-bg-s fade show');
                    $("form")[0].reset();
                    return;
              } else if(driverOffer < passengerOffer) {
                    
                sendDataToServer(driverOffer, callNo, () => {
                          // AJAX 요청이 완료된 후에 페이지 reload
                          self.location = "/community/getDealList";
                });
              }
            })
          }
      });
      
      
  });
  
    function sendDataToServer(driverOffer, callNo, callback) {
        // AJAX 요청 설정
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/community/json/addDealDriver', true);
        xhr.setRequestHeader('Content-Type', 'application/json');
  
        console.log("sendDataToServer")
        console.log(driverOffer)
        console.log(callNo)
        alert("sendDataToServer")
        
        const data = {
                driverOffer: driverOffer,
                callNo: callNo
        };
  
        // AJAX 요청 수행
        xhr.onload = function () {
            if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                console.log(response);
                if (callback) {
                    callback();
                }
            } else {
                console.error('서버에 데이터 전송 실패');
            }
        };
  
        xhr.send(JSON.stringify(data));
    }
  
    function deleteDealDriver(){
      $('#notification-bar-6').removeClass('notification-bar glass-effect detached rounded-s shadow-l')
          .addClass('notification-bar glass-effect detached rounded-s shadow-l fade show');
      $(".delbt").on("click", function() {
        $.ajax({
                  url: "/community/json/deleteDealReq",
                  type: "GET",
                  dataType: "json",
                  success: function (response){
                      console.log(response); // 콘솔에 출력

                      location.reload();
                  }
              })
      })
      
                
  
    }
      
    
    
  </script>
  
</head>

<body class="theme-light">

  <div id="page">
    <div class="page-content header-clear-medium">
    
      <div class="card card-style">
        <div class="content">
          <h3 class="pb-2">택시비 딜 리스트 조회</h3>
        </div>
      </div>
      
      <c:forEach var="call" items="${callList}" varStatus="status">
        <div class="card card-style">
          <div class="content">
            <div class="col-12">
              출발 : ${call.startAddr}<br/>
              도착 : ${call.endAddr}<br/>
            </div>
            <div class="col-8">
              <c:set var="deal" value="${dealList[status.index]}"/>
              배차 번호 : <span class="callNo">${deal.callNo}</span><br/>
              제시 금액 : <span class="passengerOffer">${deal.passengerOffer}</span><br/>
            </div>
            <div class="col-4">
              <c:if test="${deal.callNo==callNo}">
                <button type="button" onclick="deleteDealDriver()" class="btn-xxs btn border-blue-dark color-blue-dark">
                  삭제
                </button>
              </c:if>
              <c:if test="${deal.callNo!=callNo || callNo==null}">
                <button type="button" class="reqbt btn-xxs btn border-blue-dark color-blue-dark">
                  제시
                </button>
              </c:if>
            </div>
          </div>
        </div>
      </c:forEach>
    
    </div> <!-- page-content header-clear-medium -->
    
    <!-- iOS Toast Bar-->
      <div id="notification-bar-5" class="notification-bar glass-effect detached rounded-s shadow-l" data-bs-delay="15000">
        <div class="toast-body px-3 py-3">
          <div class="d-flex">
            <div class="align-self-center">
              <span class="icon icon-xxs rounded-xs bg-fade-red scale-box"><i class="bi bi-exclamation-triangle color-red-dark font-16"></i></span>
            </div>
            <div class="align-self-center">
              <h5 class="font-16 ps-2 ms-1 mb-0">제시금액</h5>
            </div>
          </div>
          <div class="align-self-center">
          <form class="demo-animation needs-validation m-0" novalidate>
          <input type="text" class="form-control rounded-xs" id="driverOffer" name="driverOffer"/>
          </form>
          </div>
          <div class="row">
            <div class="col-6">
              <a href="#" data-bs-dismiss="toast" class="btn btn-s text-uppercase rounded-xs font-11 font-700 btn-full btn-border border-fade-red color-red-dark" aria-label="Close">취소</a>
            </div>
            <div class="col-6">
              <a href="#" data-bs-dismiss="toast" class="btn btn-s text-uppercase rounded-xs font-11 font-700 btn-full btn-border bg-red-dark color-red-dark offerbt" aria-label="Close">제시하기</a>
            </div>
          </div>
        </div>
      </div>
    <!-- iOS Toast Bar 끝-->
    
    <!-- iOS Toast Bar-->
      <div id="notification-bar-6" class="notification-bar glass-effect detached rounded-s shadow-l" data-bs-delay="15000">
        <div class="toast-body px-3 py-3">
          <div class="d-flex">
            <div class="align-self-center">
              <span class="icon icon-xxs rounded-xs bg-fade-red scale-box"><i class="bi bi-exclamation-triangle color-red-dark font-16"></i></span>
            </div>
            <div class="align-self-center">
              <h5 class="font-16 ps-2 ms-1 mb-0">택시비 딜 참여를 취소하시겠습니까?</h5>
            </div>
          </div>
          <div class="row">
            <div class="col-6">
              <a href="#" data-bs-dismiss="toast" class="btn btn-s text-uppercase rounded-xs font-11 font-700 btn-full btn-border border-fade-red color-red-dark" aria-label="Close">취소</a>
            </div>
            <div class="col-6">
              <a href="#" data-bs-dismiss="toast" class="btn btn-s text-uppercase rounded-xs font-11 font-700 btn-full btn-border bg-red-dark color-red-dark delbt" aria-label="Close">확인</a>
            </div>
          </div>
        </div>
      </div>
    <!-- iOS Toast Bar 끝-->
    
    <!--Warning Toast Bar-->
      <div id="toast-top-2" class="toast toast-bar toast-top rounded-l bg-red-dark shadow-bg shadow-bg-s" data-bs-delay="3000">
    
        <div class="align-self-center">
          <i class="icon icon-s bg-white color-red-dark rounded-l shadow-s bi bi-exclamation-triangle-fill font-22 me-3"></i>
        </div>
        
        <div class="align-self-center">
          <span class="font-11 mt-n1 opacity-70">입력된 금액이 제시 금액을 초과합니다.</span>
        </div>
        
        <div class="align-self-center ms-auto">
          <button type="button" class="btn-close btn-close-white me-2 m-auto font-9" data-bs-dismiss="toast"></button>
        </div>
        
      </div>
    <!--Warning Toast Bar 끝 -->
    
  </div> <!-- page -->

  <!-- templates 설정 -->
  <script src="/templates/scripts/bootstrap.min.js"></script>
  <script src="/templates/scripts/custom.js"></script>
  <!-- templates 설정 끝 -->

</body>
</html>