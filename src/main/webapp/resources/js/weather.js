

/*
$(()=>
{
	// 현재 날짜 가져오기
	function convertTime()
	{
	    var now = new Date();
	    var month = now.getMonth() + 1; 
	    var date = now.getDate();
	    return month + '월' + date + '일';
	}
	var currentTime = convertTime();
	$('.nowTime').append(currentTime);
});


	$.ajax
({
	//https://cors-anywhere.herokuapp.com/ 크로스오리진 
	// openweather 사용: 대전 날씨 가져오기
    url: 'http://cors-anywhere.herokuapp.com/api.openweathermap.org/data/2.5/weather?q=daejeon&appid=b3b41eae716e8329e1ff8d06e13e93d1&units=metric',
    dataType: 'json',
    type: 'GET',
    success: function(data) 
		{
		console.log("check");
        var $Temp = ' '+Math.floor(data.main.temp) + '°C ';
        var $city = data.name;

    // 날씨 아이콘 변경
    	const changeWeatherIcon = (description) =>
			{
	            let iconClass = '';
	            let iconColor ='';

	            if (description == 'clear sky')
				{
	                iconClass = 'xi-sun xi-2x';
	                iconColor = 'orange';
	            }
				else if (description == 'few clouds')
				{
	                iconClass = 'xi-partly-cloudy xi-2x';
	                iconColor = 'gray';
	            }
				else if (description.includes('clouds') || !(description == 'few clouds'))
				{
	                iconClass = 'xi-cloudy xi-2x';
	                iconColor = 'skyblue';
	            }
				else if (description.includes('rain'))
				{
	                iconClass = 'xi-pouring xi-2x';
	                iconColor = 'skyblue';
	            }
				else if (description == 'thunderstorm')
				{
	                iconClass = 'xi-lightning xi-2x';
	                iconColor = 'gray';
	            }
				else if (description == 'snow')
				{
	                iconClass = 'xi-snowy xi-2x';
	                iconColor = 'gray';
	            }
				else if (description == 'mist')
				{
	                iconClass = 'xi-foggy xi-2x';
	                iconColor = 'gray';
	            }
	            return { iconClass, iconColor };
        }

const changeWeatherDescription = (description) => {
    switch(description) {
        case 'clear sky':
            return '맑음';
        case 'few clouds':
            return '구름 조금';
        case 'scattered clouds':
            return '구름 조금';
        case 'broken clouds':
            return '구름';
        case 'overcast clouds':
            return '흐림';
        case 'light rain':
            return '가벼운 비';
        case 'moderate rain':
            return '보통 비';
        case 'heavy intensity rain':
            return '강한 비';
        case 'very heavy rain':
            return '강한 비';
        case 'thunderstorm with rain':
            return '천둥번개';
        case 'thunderstorm with heavy rain':
            return '천둥번개';
        case 'thunderstorm with light rain':
            return '천둥번개';
        case 'thunderstorm':
            return '천둥번개';
        case 'snow':
            return '눈';
        case 'mist':
            return '안개';
        default:
            return description; // 기타 경우는 그대로 반환
    }
}



	    // 날씨 아이콘 추가 및 변경
	    const weatherDescription = data.weather[0].description;
	    const { iconClass, iconColor } = changeWeatherIcon(weatherDescription);
	    const koreanWeatherDescription = changeWeatherDescription(weatherDescription);
	    const iconHtml = '<i class="' + iconClass + '" style="color: ' + iconColor + ';"></i>';
	    $('.weather_icon').html(iconHtml).append($Temp).append(koreanWeatherDescription);
	    //$('.currTemp').html($Temp);
	    //$('.city').html($city);
	    //$("#weather-desc").html(changeWeatherDescription);
		},
	      error:function(xhr){
        	console.log("에러"+xhr.status);
	}
});

 */