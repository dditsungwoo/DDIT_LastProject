
$(()=>{
	    $("#jstree1").jstree({
	        'core': {
	            'data': function(obj, cb) {
	                var xhr = new XMLHttpRequest();
	                xhr.open("get", "/menu/selectMenu", true);
	                xhr.onreadystatechange = function() {
	                    if (xhr.readyState == 4 && xhr.status == 200) {
	                        var data = JSON.parse(xhr.responseText);
	                        var groupedData = groupData(data);
	                        var transformedData = transformData(groupedData);
	                        cb.call(obj, transformedData);
	                    }
	                };
	                xhr.send();
	            },
	        },
	        "plugins": ["wholerow", "dnd", "checkbox"],
	        "checkbox": {
	            "three_state": false,
	        }
	    });
});

// 데이터 그룹화 함수
function groupData(data) {
    var groupedData = {};
    data.forEach(task => {
        if (!groupedData[task.menuNo]) {
            groupedData[task.menuNo] = [];
        }
        groupedData[task.menuNo].push(task);
    });
    return groupedData;
}

//최상위 노드의 체크박스 숨기기
$('#jstree1').on('load_node.jstree', function (e, data) {
    var topLevelNodes = $('#jstree1').jstree(true).get_node('#').children;
    topLevelNodes.forEach(function(nodeId) {
        $('#' + nodeId).find('.jstree-checkbox').hide(); // 해당 노드의 체크박스를 숨김
    });
});

// 데이터 변환 함수
function transformData(groupedData) {
    var nodes = [];
    for (var deptNo in groupedData) {
        var deptInfo = groupedData[deptNo][0]; // 부서 정보는 배열의 첫 번째 요소에서 가져옴
        var deptNode = {
            id: deptInfo.menuNo,
            text: deptInfo.menuNm,
            parent: deptInfo.upperMenu,
            icon:  deptInfo.menuIcon,
        };
        nodes.push(deptNode);
	
    }
    return nodes;
}


