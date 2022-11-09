

class APIPath {

  static String job(String uid, String jobId) => '/users/$uid/jobs/$jobId';
  static String project(String uid, String projectId) => '/users/$uid/projects/$projectId';
  static String task(String uid, String projectId, String taskId) => '/users/$uid/projects/$projectId/tasks/$taskId';

  static String projects(String uid) => '/users/$uid/projects';

}