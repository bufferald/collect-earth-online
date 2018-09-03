<#include "header.ftl">
<#include "navbar.ftl">
<#include "start-content.ftl">

<script type="text/babel" src="${root}/js/Main.js"></script>
<script type="text/javascript">
	let nonPendingUsers="";
	let pageMode = "view";
    let imageryMode = "view";
    let isAdmin=false;
    $(function() {initialize();});
    function initialize() {
        if(typeof(renderInstitution)=="undefined")
            setTimeout(initialize,250);
        else
            renderInstitution("${root}", "${userid}","${institution_id}","${of_users_api_url}","${role}","${storage}",nonPendingUsers,pageMode);
    }
</script>

<div id="institution">
    <div class="row">
	    <div id="imagery-list" class="col-lg-4 col-xs-12" >
	        <h2 class="header">Imagery <span class="badge badge-pill badge-light">{{ institution.imageryList.length }}</span></h2>
	        		<div ng-if="institution.imageryMode == 'view'">
		            <div class="row mb-1" ng-repeat="imagery in institution.imageryList">
			            		<div ng-if="institution.isAdmin == false" class="col mb-1">
			               		<button class="btn btn-outline-lightgreen btn-sm btn-block" >{{ imagery.title }}</button>
			                </div>
		    	            		<div ng-if="institution.isAdmin == true" class="col-10 pr-1 ">
			               		<button class="btn btn-outline-lightgreen btn-sm btn-block" >{{ imagery.title }}</button>
			               	</div>
		    	            		<div ng-if="institution.isAdmin == true" class="col-2 pl-0">
				                <button class="btn btn-outline-danger btn-sm btn-block" ng-if="institution.isAdmin == true" id="delete-imagery" type="button" ng-click="institution.deleteImagery(imagery.id)">
				                		<span class="d-none d-xl-block">Delete</span>
				                		<span class="d-xl-none"><i class="fa fa-trash-alt"></i></span>
				                </button>
			            		</div>
		            </div>
	        	        <div class="row">
			        		<div class="col-lg-12 mb-1">
			        		        <button ng-if="institution.isAdmin == true" type="button" id="add-imagery-button" class="btn btn-sm btn-block btn-outline-yellow" ng-click="institution.toggleImageryMode()">
			        		        <i class="fa fa-plus-square"></i> Add New Imagery
			        		        </button>
		             	</div>
		             </div>
	            </div>
	            <div class="row" id="add-imagery" ng-if="institution.isAdmin == true && institution.imageryMode == 'edit'">
	            		<div class="col">
				        <form class="mb-2 p-2 border rounded">
				            <div class="form-group">
				                <label for="newImageryTitle">Title</label>
				                <input class="form-control" id="newImageryTitle" type="text" name="imagery-title" autocomplete="off" ng-model="institution.newImageryTitle">
				            </div>
				            <div class="form-group">
				                <label for="newImageryAttribution">Attribution</label>
				                <input class="form-control" id="newImageryAttribution" type="text" name="imagery-attribution" autocomplete="off" ng-model="institution.newImageryAttribution">
				            </div>
				            <div class="form-group">
				                <label for="newGeoServerURL">GeoServer URL</label>
				                <input class="form-control" id="newGeoServerURL" type="text" name="imagery-geoserver-url" autocomplete="off" ng-model="institution.newGeoServerURL">
				            </div>
				            <div class="form-group">
				                <label for="newLayerName">GeoServer Layer Name</label>
				                <input class="form-control" id="newLayerName" type="text" name="imagery-layer-name" autocomplete="off" ng-model="institution.newLayerName">
				            </div>
				            <div class="form-group">
				                <label for="newGeoServerParams">GeoServer Params<br>(as JSON string)</label>
				                <input class="form-control" id="newGeoServerParams" type="text" name="imagery-geoserver-params" autocomplete="off" ng-model="institution.newGeoServerParams">
				            </div>
				            <div class="btn-group-vertical btn-block">
					            <button id="add-imagery-button" ng-if="institution.isAdmin == true" class="btn btn-sm btn-block btn-outline-yellow btn-group" ng-click="institution.toggleImageryMode()">
			               			<i class="fa fa-plus-square"></i> Add New Imagery
		               			</button>
		               			<button  class="btn btn-sm btn-block btn-outline-danger btn-group"  ng-click="institution.cancelAddCustomImagery()">Cancel</button>
	               			</div>
				        </form>
			        </div>
		        </div>
	    </div>
	  <div id="project-list" class="col-lg-4 col-xs-12">
	      <h2 class="header">Projects <span class="badge badge-pill  badge-light">{{ institution.projectList.length }}</span></h2>
	          <div class="row mb-1" ng-if="institution.isAdmin == true">
		          <div class="col">
		          	<button id="create-project" type="button" class="btn btn-sm btn-block btn-outline-yellow"
		                     ng-click="institution.createProject()" >
		                     <i class="fa fa-plus-square"></i> Create New Project
	                </button>
				</div>
	          </div>
	          <div class="row mb-1" ng-if="institution.isAdmin == true" ng-repeat="project in institution.projectList">
	          	<div class="col-9 pr-1">
	             	<a class="btn btn-sm btn-outline-lightgreen btn-block" href="${root}/collection/{{ project.id }}">
	             		{{ project.name }}
	             	</a>
              	</div>
				<div class="col-3 pl-0">
              		<a class="btn btn-sm btn-outline-lightgreen btn-block" class="edit-project" href="${root}/project/{{ project.id }}">
              		<span class="d-xl-none"><i class="fa fa-edit"></i></span><span class="d-none d-xl-block"> Review</span></a>
              	</div>
	          </div>
	          <div class="row" ng-if="institution.isAdmin == false" ng-repeat="project in institution.projectList">
	          	<div class="col mb-1 pr-1">
	             	<a class="btn btn-sm btn-outline-lightgreen btn-block" href="${root}/collection/{{ project.id }}">
	             		{{ project.name }}
	             	</a>
              	</div>
            	</div>
	  </div>
    <div id="user-list" class="col-lg-4 col-xs-12">
        <h2 ng-if="institution.isAdmin == true" class="header">Users <span class="badge badge-pill  badge-light">{{ institution.userList.length }}</span></h2>
        <h2 ng-if="institution.isAdmin == false" class="header">Users <span class="badge badge-pill  badge-light">{{ institution.nonPendingUsers }}</span></h2>
            <div class="row" ng-repeat="user in institution.userList">
            		<div class="col mb-1" ng-if="institution.isAdmin == false && user.institutionRole != 'pending'" >
              	  	<a class="btn btn-sm btn-outline-lightgreen btn-block" href="${root}/account/{{ user.id }}">{{ user.email }}</a>
            		</div>
            		<div class="col-9 mb-1 pr-1" ng-if="institution.isAdmin == true" >
	                <a class="btn btn-sm btn-outline-lightgreen btn-block " href="${root}/account/{{ user.id }}">{{ user.email }}</a>
	            </div>
	            <div class="col-3 mb-1 pl-0"  ng-if="institution.isAdmin == true" >
	                <select class="custom-select custom-select-sm" name="user-institution-role" size="1"
	                        ng-model="user.institutionRole"
	                        ng-change="institution.updateUserInstitutionRole(user.id, user.email, user.institutionRole)">
	                    <option ng-if="user.institutionRole == 'pending'" value="pending">Pending</option>
	                    <option value="member">Member</option>
	                    <option value="admin">Admin</option>
	                    <option value="not-member">Remove</option>
	                </select>
				</div>

            </div>
            <div class="row mb-1" ng-if="institution.isAdmin == true">
	            	<div class="col-9 pr-1">
	   	              <input class="form-control form-control-sm" type="email" name="new-institution-user" autocomplete="off" placeholder="Email" ng-model="institution.newUserEmail">
 	            	</div>
 	            	<div class="col-3 pl-0">
	                <button class="btn btn-sm btn-outline-yellow btn-block" name="add-institution-user" ng-click="institution.addUser()"><span class="d-xl-none"><i class="fa fa-plus-square"></i></span> <span class="d-none d-xl-block">Add User</span></button>
	            	</div>
            </div>
            <div ng-if="institution.userId != '' && institution.details.id > 0 && !institution.isInstitutionMember(institution.userId)">
                       <button class="btn btn-sm btn-outline-yellow btn-block mb-2" id="request-membership-button" name="request-membership-button"  ng-click="institution.requestMembership()"><i class="fa fa-plus-square"></i> Request membership</button>
            </div>

    </div>
    </div>
</div>

<#include "end-content.ftl">
<#include "footer.ftl">
