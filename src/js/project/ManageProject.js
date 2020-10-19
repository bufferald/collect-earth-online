import React from "react";

import ReviewForm from "./ReviewForm";

import {convertSampleValuesToSurveyQuestions} from "../utils/surveyUtils";
import {ProjectContext} from "./constants";

export default class ManageProject extends React.Component {

    componentDidMount() {
        this.context.processModal("Loading Project Details", this.getProjectDetails);
    }

    /// API Calls

    getProjectDetails = () =>
        Promise.all([this.getProjectById(this.context.projectId),
                     this.getProjectImagery(this.context.projectId),
                     this.getProjectPlots(this.context.projectId)])
            .catch(response =>{
                console.log(response);
                alert("Error retrieving the project info. See console for details.");
            })

    getProjectById = (projectId) =>
        fetch(`/get-project-by-id?projectId=${projectId}`)
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                if (data === "") {
                    alert("No project found with ID " + projectId + ".");
                    window.location = "/home";
                } else {
                    const newSurveyQuestions = convertSampleValuesToSurveyQuestions(data.sampleValues);
                    this.context.setProjectState({...data, surveyQuestions: newSurveyQuestions});
                }
            })
            .catch(() => Promise.reject("Error retrieving the project."));

    // TODO: just return with the project info
    getProjectImagery = (projectId) =>
        fetch("/get-project-imagery?projectId=" + projectId)
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                this.context.setProjectState({projectImageryList: data.map(imagery => imagery.id)});
            })
            .catch(() => Promise.reject("Error retrieving the project imagery list."));

    getProjectPlots = (projectId) =>
        fetch(`/get-project-plots?projectId=${projectId}&max=300`)
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => this.context.setProjectState({plots: data}))
            .catch(() => Promise.reject("Error retrieving plot list. See console for details."));

    render() {
        return (
            <div
                id="review-project"
                className="d-flex flex-column full-height align-items-center p-3"
            >
                <div
                    style={{
                        display: "flex",
                        height: "100%",
                        justifyContent: "center",
                        width: "100%",
                        overflow: "auto",
                    }}
                >
                    <div
                        className="col-7 px-0 mr-2 overflow-auto bg-lightgray"
                        style={{border: "1px solid black", borderRadius: "6px"}}
                    >
                        <h2 className="bg-lightgreen w-100 py-1">Project Details</h2>
                        <div className="px-3 pb-3">
                            <ReviewForm/>
                        </div>
                    </div>
                    <div
                        className="col-4 px-0 mr-2 overflow-auto bg-lightgray"
                        style={{border: "1px solid black", borderRadius: "6px"}}
                    >
                        <h2 className="bg-lightgreen w-100 py-1">Project Management</h2>
                        <div className="p-3">
                            <ProjectManagement/>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}
ManageProject.contextType = ProjectContext;

class ProjectManagement extends React.Component {
    constructor(props) {
        super(props);
        this.stateTransitions = {
            unpublished: "Publish",
            published: "Close",
            closed: "Publish",
        };
        this.projectStates = {
            unpublished: {
                button: "Publish",
                update: this.publishProject,
                description: "Admins can review, edit (currently limited), and test collecting the project.  Publish the project in order for users to begin collection.",
                canEdit: true,
            },
            published: {
                button: "Close",
                update: this.closeProject,
                description: "Users can begin collecting.  Limited changes to the project details can be made.  Close the project to prevent anymore updates.",
                canEdit: true,
            },
            closed: {
                button: "Reopen",
                update: this.publishProject,
                description: "The project is closed to all changes.  Reopen the project for additional collection.",
                canEdit: false,
            },
        };
    }

    /// API Calls

    publishProject = () => {
        const unpublished = this.context.projectDetails.availability === "unpublished";
        const message = unpublished
            ? "Do you want to publish this project?  This action will clear plots collected by admins to allow collecting by users."
            : "Do you want to re-open this project?  Members will be allowed to collect plots again.";
        if (confirm(message)) {
            fetch(`/publish-project?projectId=${this.context.projectDetails.id}&clearSaved=${unpublished}`,
                  {method: "POST"})
                .then(response => {
                    if (response.ok) {
                        this.context.setProjectState({availability: "published"});
                    } else {
                        console.log(response);
                        alert("Error publishing project. See console for details.");
                    }
                });
        }
    };

    closeProject = () => {
        if (confirm("Do you want to close this project?")) {
            fetch(`/close-project?projectId=${this.context.projectDetails.id}`, {method: "POST"})
                .then(response => {
                    if (response.ok) {
                        this.context.setProjectState({availability: "closed"});
                    } else {
                        console.log(response);
                        alert("Error closing project. See console for details.");
                    }
                });
        }
    };

    deleteProject = () => {
        if (confirm("Do you want to delete this project? This operation cannot be undone.")) {
            fetch(`/archive-project?projectId=${this.context.projectDetails.id}`, {method: "POST"})
                .then(response => {
                    if (response.ok) {
                        alert("Project " + this.context.projectDetails.id + " has been deleted.");
                        window.location = `/review-institution?institutionId=${this.context.projectDetails.institution}`;
                    } else {
                        console.log(response);
                        alert("Error deleting project. See console for details.");
                    }
                });
        }
    };

    render() {
        const {availability, createdDate, publishedDate, closedDate, institution, id} = this.context.projectDetails;
        const {button, update, description, canEdit} = this.projectStates[availability] || {};
        return (
            <div id="project-management" className="d-flex flex-column">
                <div className="d-flex">
                    <div className="col-7">
                        <div className="ProjectStats__dates-table mb-4">
                            <div className="d-flex flex-column">
                                <div className="">
                                    Date Created
                                    <span className="badge badge-pill bg-lightgreen ml-3">
                                        {createdDate || "Unknown"}
                                    </span>
                                </div>
                                <div className="">
                                    Date Published
                                    <span className="badge badge-pill bg-lightgreen ml-3">
                                        {publishedDate
                                            || (availability === "unpublished"
                                        ? "Unpublished"
                                        : "Unknown" )}
                                    </span>
                                </div>
                                <div className="">
                                    Date Closed
                                    <span className="badge badge-pill bg-lightgreen ml-3">
                                        {closedDate
                                            || (["archived", "closed"].includes(availability)
                                        ? "Unknown"
                                        : "Open")}
                                    </span>
                                </div>
                            </div>
                        </div>
                        <p>This project is <b>{availability}</b>. {description}</p>
                    </div>
                    <div className="col-5 d-flex flex-column align-items-center">
                        <h3 className="my-2">Modify Project Details</h3>
                        <input
                            className="btn btn-outline-red btn-sm w-100"
                            type="button"
                            value={(button || "Close") + " Project"}
                            onClick={() => update.call(this)}
                        />
                        <input
                            className="btn btn-outline-red btn-sm w-100"
                            type="button"
                            value="Edit Project"
                            disabled={!canEdit}
                            onClick={() => this.context.setDesignMode("wizard")}
                        />
                        <input
                            className="btn btn-outline-red btn-sm w-100"
                            type="button"
                            value="Delete Project"
                            onClick={this.deleteProject}
                        />
                        <h3 className="my-2">External Links</h3>
                        <input
                            className="btn btn-outline-lightgreen btn-sm w-100"
                            type="button"
                            value="Configure Geo-Dash"
                            onClick={() => window.open(
                                "/widget-layout-editor?editable=true&" // TODO, drop unused 'editable'
                                    + `institutionId=${institution}`
                                    + `&projectId=${id}`,
                                "_geo-dash"
                            )}
                        />
                        <input
                            className="btn btn-outline-lightgreen btn-sm w-100"
                            type="button"
                            value="Collect"
                            onClick={() => window.open(`/collection?projectId=${id}`)}
                        />
                        <input
                            className="btn btn-outline-lightgreen btn-sm w-100"
                            type="button"
                            value="Project Dashboard"
                            onClick={() => window.open(`/project-dashboard?projectId=${id}`)}
                        />
                        <h3 className="my-2">Export Data</h3>
                        <input
                            className="btn btn-outline-lightgreen btn-sm w-100"
                            type="button"
                            value="Download Plot Data"
                            onClick={() => window.open(`/dump-project-aggregate-data?projectId=${id}`, "_blank")}
                        />
                        <input
                            className="btn btn-outline-lightgreen btn-sm w-100"
                            type="button"
                            value="Download Sample Data"
                            onClick={() => window.open(`/dump-project-raw-data?projectId=${id}`, "_blank")}
                        />
                    </div>
                </div>
            </div>
        );
    }
}
ProjectManagement.contextType = ProjectContext;
