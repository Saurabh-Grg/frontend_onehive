class ApiEndpoints{
  // replace with laptop IP address for testing in real device
  // static const baseUrl = "http://169.254.117.17:3000/api/";
  static const baseUrl = "http://localhost:3000/api/";
  static const messageBaseUrl = "http://localhost:3000";

  static const register = "${baseUrl}auth/register";
  static const login = "${baseUrl}auth/login";
  static const forgotPassword = "${baseUrl}auth/forgot-password";
  static const verifyOtp = "${baseUrl}auth/verify-otp";
  static const resetPassword = "${baseUrl}auth/reset-password";

  static const freelancerMyProfile = "${baseUrl}freelancerProfile/my-profile";
  static const checkFreelancerProfile = "${baseUrl}freelancerProfile/check-profile";
  static const createFreelancerProfile = "${baseUrl}freelancerProfile/create";
  static const getFreelancerProfileByClient = "${baseUrl}freelancerProfile/freelancer-profile";

  static const createClientProfile = "${baseUrl}clientProfile/client-profile";
  static const checkClientProfile = "${baseUrl}clientProfile/check-profile";
  static const fetchClientProfile = "${baseUrl}clientProfile/client-profile";
  static const updateClientProfile = "${baseUrl}clientProfile/client-profile/update";

  static const storeCommonJobDetails = "${baseUrl}jobPosting/store-temp-job";
  static const getJobs = "${baseUrl}jobPosting/jobs";
  static const countTotalJobPostingByAClient = "${baseUrl}jobPosting/totalJobPostings";
  static const getTotalJobsPostedByAClient = "${baseUrl}jobPosting/jobs";
  static const jobDetails = "${baseUrl}jobPosting/jobDetails";
  static const deleteJob = "${baseUrl}jobPosting";

  static const submitBackendJobPosting = "${baseUrl}jobPosting/submit-backend-job";

  static const submitProposal = "${baseUrl}proposals/submit";
  static const getTotalNumberOfProposalForAClient = "${baseUrl}proposals/total-proposals";
  static const getProposalForAClient = "${baseUrl}proposals/client";
  static const acceptProposalByClient = "${baseUrl}proposals/accept"; // /proposal_id

  static const getFollowList = "${baseUrl}follow/follow-lists";
  static const getFreelancerFollowStatus = "${baseUrl}follow/status";
  static const followFreelancer = "${baseUrl}follow/follow";
  static const unFollowFreelancer = "${baseUrl}follow/unfollow";

  static const likeOrUnlikeJobs = "${baseUrl}liked-jobs/like-job";
  static const getLikedJobs = "${baseUrl}liked-jobs/liked-jobs";

  static const fetchNotifications = "${baseUrl}notifications";
  static const markAllNotificationAsRead = "${baseUrl}notifications/user";
}


