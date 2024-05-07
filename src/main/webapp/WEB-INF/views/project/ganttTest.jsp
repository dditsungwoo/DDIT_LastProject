<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/spectrum/1.8.1/spectrum.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/spectrum/1.8.1/spectrum.min.css">
<script src="/resources/gantt/codebase/dhtmlxgantt.js"></script>
<link href="/resources/gantt/codebase/dhtmlxgantt.css" rel="stylesheet">
<script src="/resources/gantt/codebase/dhtmlxgantt.js?v=8.0.6"></script>
<script src="/resources/gantt/samples/common/testdata.js?v=8.0.6"></script> 
<link rel="stylesheet" href="https://docs.dhtmlx.com/gantt/codebase/skins/dhtmlxgantt_material.css">
<link href="/resources/css/project/gantt.css" rel="stylesheet"> 
 
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">간트차트</h1>
	</div>
    <!-- =============== 상단타이틀영역 끝 =============== -->
<!-- =============== 컨텐츠 영역 시작 =============== -->
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
	<div class="tab-type tab-type1" style="float: right;">
		<div class="side-util">
			<div class="tab-menu">
				<label for="toKanban"><button data-tab="tab1" type="button"
						class="tab-btn" id="toKanban">칸반 차트</button></label>
				<button data-tab="tab2" type="button" class="tab-btn active"
					id="toGantt">간트 차트</button>
				<div class="tab-indicator"
					style="width: 140px; transform: translateX(140px);"></div>
			</div>

			<!-- tab1  -->
			<div data-tab="tab1" class="tab-content">
				<ul class="tab-board-lst">
				</ul>
			</div>

			<!-- tab2  -->
			<div data-tab="tab2" class="tab-content active">
				<ul class="tab-board-lst">
				</ul>
			</div>
		</div>
	</div>
	<div class="wf-content-area">
		<div id="e7eGantt" style='width: 80vw; height: 100vh;'></div>

		<div class="wf-flex-box downBox box3" >
			<div class="wf-content-box grappBox">		
				<p class="heading1 process">그래프 색깔</p>
					<br>
					<p class="heading1 process">
						시작 : <span class="progress-dot started"></span>
					</p>
					<p class="heading1 process">
						진행중: <span class="progress-dot in-progress"></span>
					</p>
					<p class="heading1 process">
						완료 :<span class="progress-dot completed"></span>
					</p>
				</div>	
				<div class="wf-content-box contsBox">
					<p class="heading1">상세 정보</p>
					<div id="contDiv"></div>
				</div>
				<div class="wf-content-box resBox">
					<p class="heading1">진행률</p>
					<div id="resDiv"></div>
				</div>
			</div>

	</div>
	</div>
</div>
<script>
$(()=>{
	
	  $("#toKanban").on("click",function(){
 		  console.log("kanban");
 		  location.href="/project/project/${prjctNo}";
 		  
 	  });
	  
	  $(".gantt_task_line").off("click").on("click", function() {
		  console.log("안녕");
	  })
	  

	  fData(prjctNo);
	  
	  $(document).on("click",".gantt_task_line",function(event){
	  	 
		  event.preventDefault();
		  
		  let id= $(this).data("taskId");
		  console.log(id);
		  let data={
			prjctDutyNo:id	  
		  };
	       $.ajax({
           	url:"/project/getDutyModal",
       		data:JSON.stringify(data),
       		contentType:"application/json;charset=utf-8",
       		type:"post",
       		dataType:"json",
       		beforeSend:function(xhr){
       			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
       		},
       		success:function(res){ 
       			$("#contDiv").html('');
       			console.log(res);
       			let str='';
       			let str2='';
       			str += `
       					<p class="heading1">일감명  : \${res.dutySj}</p>       				
       					<p class="heading1">마감일자: \${res.prjctEndDate}</p>       					
       					<p class="heading1">일감 상세: \${res.detailCn}</p>
     			`;
     			$("#contDiv").html(str);
     			let prgsRate=parseInt(res.prgsRate)*10;
     			str2 += "<p class='heading1' style='font-size:55px;'>"+prgsRate+"%</p> ";
     			$("#resDiv").html(str2);
       		}
	  })
	  });
	

	  //ganttFirst();
	  
});	
	  
        function calculateResourceLoad(tasks, scale) {
            var step = scale.unit;
            var timegrid = {};

            for (var i = 0; i < tasks.length; i++) {
                var task = tasks[i];

                var currDate = gantt.date[step + "_start"](new Date(task.startDate));

                while (currDate < task.endDate) {

                    var date = currDate;
                    currDate = gantt.date.add(currDate, 1, step);

                    if (!gantt.isWorkTime({ date: date, task: task })) {
                        continue;
                    }

                    var timestamp = date.valueOf();
                    if (!timegrid[timestamp])
                        timegrid[timestamp] = 0;

                    timegrid[timestamp] += 8;
                }
            }

            var timetable = [];
            var start, end;
            for (var i in timegrid) {
                start = new Date(i * 1);
                end = gantt.date.add(start, 1, step);
                timetable.push({
                    startDate: start,
                    endDate: end,
                    value: timegrid[i]
                });
            }

            return timetable;
        }


        var renderResourceLine = function (resource, timeline) {
            var tasks = gantt.getTaskBy("user", resource.id);
            var timetable = calculateResourceLoad(tasks, timeline.getScale());

            var row = document.createElement("div");

            for (var i = 0; i < timetable.length; i++) {

                var day = timetable[i];

                var css = "";
                if (day.value <= 8) {
                    css = "gantt_resource_marker gantt_resource_marker_ok";
                } else {
                    css = "gantt_resource_marker gantt_resource_marker_overtime";
                }

                var sizes = timeline.getItemPosition(resource, day.startDate, day.endDate);
                var el = document.createElement('div');
                el.className = css;

                el.style.cssText = [
                    'left:' + sizes.left + 'px',
                    'width:' + sizes.width + 'px',
                    'position:absolute',
                    'height:' + (gantt.config.row_height - 1) + 'px',
                    'line-height:' + sizes.height + 'px',
                    'top:' + sizes.top + 'px'
                ].join(";");

                el.innerHTML = day.value;
                row.appendChild(el);
            }
            return row;
        };

        var resourceLayers = [
            renderResourceLine,
            "taskBg"
        ];

        // 색깔 에디터 추가
        let editor;
        gantt.config.editor_types.color = {
            show: function (id, column, config, placeholder) {
                var html = "<div><input type='color' name='" + column.name + "'></div>";
                placeholder.innerHTML = html;

                editor = $(placeholder).find("input").spectrum({
                    change: () => {
                        gantt.ext.inlineEditors.save();
                    }
                });

                setTimeout(() => {
                    editor.spectrum("show")
                })
            },
            hide: function () {
                if (editor) {
                    editor.spectrum("destroy");
                    editor = null;
                }
            },

            set_value: function (value, id, column, node) {
                editor.spectrum("set", value);
            },

            get_value: function (id, column, node) {
                return editor.spectrum("get").toHexString();
            },

            is_changed: function (value, id, column, node) {
                // console.log("THIS: ", this);
                var newValue = this.get_value(id, column, node);
                return newValue !== value;
            },

            is_valid: function (value, id, column, node) {
                var newValue = this.get_value(id, column, node);
                return !!newValue;
            },

            save: function (id, column, node) {
                // only for inputs with map_to:auto. complex save behavior goes here
            },
            focus: function (node) {
                editor.spectrum("show");
            }
        }

        const colorEditor = { type: "color", map_to: "color" };

        var mainGridConfig = {
            columns: [
                { name: "text", tree: true, width: 200, resize: true },
                { name: "startDate", align: "center", width: 80, resize: true },
                {
                    name: "owner", align: "center", width: 60, label: "담당자", template: function (task) {
                      // var store = gantt.getDatastore("resources");
                        var owner = task.user;
                        console.log("owner",owner);
                        if (owner) {
                            return owner;
                        } else {
                            return "디폴트";
                        }
                    }
                },
                { name: "duration", width: 50, align: "center" },
                {
                    name: "color", label: "색깔", align: "center", width: 50, resize: true, editor: colorEditor,
                    template: (task) => {
                        if (!task.color) {
                            if (task.type == "0" ||task.type == "1" ) task.color = "#51c185";
                            if (task.type == "2" ||task.type == "3" ) task.color = "#51c185";
                            if (task.type == "4" ||task.type == "5" ) task.color = "#17C653";
                            if (task.type == "6" ||task.type == "7" ) task.color = "#448aff";
                            if (task.type == "8" ||task.type == "9" ) task.color = "#448aff";
                            if (task.type == "10"  ) task.color = "#448aff";
                        }                        
                        task.color = task.color || "#51c185";
                        return `<div class="task-color-cell" style="background:${task.color}; border:none;" ></div>`;
                    }
                },
                { name: "add", width: 44 }
            ]
        };

        var resourcePanelConfig = {
            columns: [
                {
                    name: "name", label: "Name", align: "center", template: function (resource) {
                        //console.log("체킁:", resource);
                        return resource.label;
                    }
                },
                {
                    name: "workload", label: "Workload", align: "center", template: function (resource) {
                        var tasks = gantt.getTaskBy("user", resource.id);

                        var totalDuration = 0;
                        for (var i = 0; i < tasks.length; i++) {
                            totalDuration += tasks[i].duration;
                        }

                        return (totalDuration || 0) * 8 + "";
                    }
                }
            ]
        };

        gantt.config.layout = {
            css: "gantt_container",
            rows: [
                {
                    cols: [
                        { view: "grid", group: "grids", config: mainGridConfig, scrollY: "scrollVer" },
                        { resizer: true, width: 1, group: "vertical" },
                        { view: "timeline", id: "timeline", scrollX: "scrollHor", scrollY: "scrollVer" },
                        { view: "scrollbar", id: "scrollVer", group: "vertical" }
                    ]
                },
                { resizer: true, width: 1 },
                {
                    config: resourcePanelConfig,
                    cols: [
                        {
                            view: "grid",
                            id: "resourceGrid",
                            group: "grids",
                            bind: "resources",
                            scrollY: "resourceVScroll"
                        },
                        { resizer: true, width: 1, group: "vertical" },
                        {
                            view: "timeline",
                            id: "resourceTimeline",
                            bind: "resources",
                            bindLinks: null,
                            layers: resourceLayers,
                            scrollX: "scrollHor",
                            scrollY: "resourceVScroll"
                        },
                        { view: "scrollbar", id: "resourceVScroll", group: "vertical" }
                    ]
                },
                { view: "scrollbar", id: "scrollHor" }
            ]
        };

        var resourcesStore = gantt.createDatastore({
            name: "resources",
            initItem: function (item) {
                item.id = item.key || gantt.uid();
                return item;
            }
        });

        var tasksStore = gantt.getDatastore("task");
        //console.log("체킁taskStore:", tasksStore);
        tasksStore.attachEvent("onStoreUpdated", function (id, item, mode) {
            resourcesStore.refresh();
        });


        // 기본 설정
        gantt.i18n.setLocale("kr");

        gantt.config.scales = [
            { unit: "month", step: 1, format: "%Y, %F" },
            { unit: "day", step: 1, format: "%j, %D" }
        ];

        //날짜 형식
        gantt.config.date_format = "%Y-%m-%d %H:%i"; // 실제 전달되는 데이타의 startDate등의 포맷
        gantt.config.task_date = "%Y년 %m월 %d일";
		
        gantt.init("e7eGantt");
		
     /*  resourcesStore.parse([// resources
            { key: '0', label: "없음" },
            { key: '1', label: "E7E" },
            { key: '2', label: "메롱" },
            { key: '3', label: "황당" },
            { key: '4', label: "당황" },
            { key: '5', label: "우앙" },
            { key: '6', label: "오호" },
            { key: '7', label: "눈물" }
        ]);*/

     
		let prjctNo="${prjctNo}";
        const fData = async (prjctNo) => {
    		let data ={
    				"prjctNo":prjctNo
    			};
               
            $.ajax({
            	url:"/project/getDutyModalForGantt",
        		data:JSON.stringify(data),
        		contentType:"application/json;charset=utf-8",
        		type:"post",
        		dataType:"json",
        		beforeSend:function(xhr){
        			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
        		},
        		 success:function(res){  
        	    	var transformedData = transformData(res);
        	    	var transformedLink= transformLink(res);
        	       	console.log("transformedData",transformedData[0].id);
        	       	console.log("transformedLink",transformedLink);
        	       	console.log("transformedLink",transformResource(res));
        	    	gantt.parse({"data":transformedData,
        	    				"links":transformedData}); 
        	       resourcesStore.parse(transformResource(res));
        	       ganttFirst(transformedData[0].id);
        		}
            });  
        }
        
        
      //fData(prjctNo);
      
      
 /*     gantt.parse({
    data:[
        {id:1, text:"Project #2", start_date:"01-04-2023", duration:18},
        {id:2, text:"Task #1",    start_date:"02-04-2023", duration:8,
            progress:0.6, parent:1},
        {id:3, text:"Task #2",    start_date:"11-04-2023", duration:8,
            progress:0.6, parent:1}
    ] 
});
 */
     function transformData(data) {
            // 각 작업의 필드명을 수정하여 새로운 배열로 반환
         return data.map(task => {
             return {
                    id: task.id,
                    text: task.text,
                    start_date: task.startDate,
                    end_date: task.endDate,
                    progress: task.progress,
                    open: task.open,
                    duration:task.duration,
                    user:task.empNm,
                    type:task.prgsRate
                };
            });
        }
 
 function transformLink(data) {
     // 각 작업의 필드명을 수정하여 새로운 배열로 반환
  return data.map(task => {
      return {
             id: task.id,
             source: parseInt(task.progress),
             target: parseInt(task.progress)+1,
             type: parseInt(task.progress)
           
         };
     });
 }

 function transformResource(data) {
	    // 각 작업의 필드명을 수정하여 새로운 배열로 반환
	    return data.map((task, index) => {
	        return {
	            key: index,
	            label: task.empNm     
	        };
	    });
	}
 
 	function ganttFirst(id){
	  console.log("gantFisst");

	  let data={
		prjctDutyNo:id 
	  };
       $.ajax({
       	url:"/project/getDutyModal",
   		data:JSON.stringify(data),
   		contentType:"application/json;charset=utf-8",
   		type:"post",
   		dataType:"json",
   		beforeSend:function(xhr){
   			xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
   		},
   		success:function(res){ 
   			$("#contDiv").html('');
   			console.log(res);
   			let str='';
   			let str2='';
   			str += `
   					<p class="heading1">일감명  : \${res.dutySj}</p>       				
   					<p class="heading1">마감일자: \${res.prjctEndDate}</p>       					
   					<p class="heading1">일감 상세: \${res.detailCn}</p>
 			`;
 			$("#contDiv").html(str);
 			let prgsRate=parseInt(res.prgsRate)*10;
 			str2 += "<p class='heading1' style='font-size:55px;'>"+prgsRate+"%</p> ";
 			$("#resDiv").html(str2);
   		}
  })
	 
 }
 
 
 
    </script>