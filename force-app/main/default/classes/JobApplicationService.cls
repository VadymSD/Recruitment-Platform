@RestResource(urlMapping='/endpoint/*')
global class JobApplicationService {

    public static final String CREATE_METHOD = 'create';
    public static final String UPDATE_METHOD = 'update';

    @HttpGet
    global static void getJobApplication() {
        RestRequest request = RestContext.request;
        try {
            String objectId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.statusCode = 200;
            EndpointHelper.getJobApplication(objectId);
        } catch (Exception e) {
            setExceptionResponse(e);
        }
    }

    @HttpDelete
    global static void deleteJobApplication() {
        RestRequest request = RestContext.request;
        try {
            String objectId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);  
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.statusCode = 200;
            EndpointHelper.deleteJobApplication(objectId);
        } catch (Exception e) {
            setExceptionResponse(e);
        }
    }

    @HttpPost
    global static void maniputaleWithData() {
        RestRequest req = RestContext.request;
        EndpointTypeDTO type;
        EndpointDTO requestData;
        try {
            type = (EndpointTypeDTO) JSON.deserialize(req.requestBody.toString(), EndpointTypeDTO.class);
            if(type.name == CREATE_METHOD) {
                requestData = (InsertStructure) JSON.deserialize(req.requestBody.toString(), InsertStructure.class);
                EndpointHelper.insertJobApplication((InsertStructure) requestData);
            } else if(type.name == UPDATE_METHOD) {
                requestData = (UpdateStructure) JSON.deserialize(req.requestBody.toString(), UpdateStructure.class);
                EndpointHelper.updateJobApplication((UpdateStructure) requestData);
            }
        } catch (JSONException e){
            setExceptionResponse(e); 
        }
    }
     
    private static void setExceptionResponse(Exception e){
        RestContext.response.responseBody = Blob.valueOf('{ "message" : "' + e + '"}');
        RestContext.response.statusCode = 500;
    }
}
