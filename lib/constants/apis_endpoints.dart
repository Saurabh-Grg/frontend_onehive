class ApiEndpoints{
  // replace with laptop IP address for testing in real device
  static const baseUrl = "http://127.0.0.1:3000/api/";

  static const register = "${baseUrl}auth/register";
  static const login = "${baseUrl}auth/login";
  static const forgotPassword = "${baseUrl}auth/forgot-password";
  static const verifyOtp = "${baseUrl}auth/verify-otp";
  static const resetPassword = "${baseUrl}auth/reset-password";
  static const freelancerMyProfile = "${baseUrl}freelancerProfile/my-profile";
  static const checkFreelancerProfile = "${baseUrl}freelancerProfile/check-profile";
  static const createFreelancerProfile = "${baseUrl}freelancerProfile/create";
  static const createClientProfile = "${baseUrl}clientProfile/client-profile";
  static const fetchClientProfile = "${baseUrl}clientProfile/client-profile";
  static const getJobs = "${baseUrl}jobPosting/jobs";
  static const jobDetails = "${baseUrl}jobPosting/jobDetails";
  static const submitProposal = "${baseUrl}proposals/submit";
}


