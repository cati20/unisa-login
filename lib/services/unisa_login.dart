import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
import 'package:unisa/common_widgets/platform_alert_dialog.dart';

class Token with ChangeNotifier {
  /// Internal, private state of the cart.
  String cookie = null;
  String error;
  String student;




  Future<String>  myUnisa(String studentNumber , String password) async {
    final url = "https://cas.unisa.ac.za/cas/login?service=https%3a%2f%2fmyadmin.unisa.ac.za%2fmyadmin-auth-services%2fservices%2frest%2fauthservice%2fuser";

    String execution = "c78cf1c1-202d-40ed-a360-7cc73d88bece_ZXlKaGJHY2lPaUpJVXpVeE1pSjkubmhPb2ZHMloveHAxNmJyY3R2eXY0T0l4OVczbHFVa2RvS0s3UDhYOTF6NG1LdkxmQTIzVEhXVURjQ1hERnhQdVNES1RSblVMT0xEMFV6WFFDbmwrTGl0dGFxVDNDOWZvSWFqK25kSmxUY2h4M09aa2M5NHh4QUJoQ2U4UHpkWVlrWDB3aGZQZWVJdnEwbCt0cmU2d0dnallMeEVVK1ZrTHJHVVUvU2thRGJ2N1B0NTR5UEJreEowSmtiZ0ZUMHNTMmg2MFZzaGZLazdybFlSaSttYlB5UmN4c2w0VlRIRlFacVN3by9FNWQ1OGtPNHgzRE5qU1hXU2ZGUkpaNzA3VXpnT2toZ25EMEtzNnlodDhyM3pGTlNBL3hEVlpKS0JSVy90L2ZQazBCY3JTbTk1Yk92MnplRzBib2JUNVZUb1lKVjdPYTg0a2dYaG9rbE1SYWlld2ZqcFZxbEhDeWJSbW15OUdxVnExTTFXR0t6MXZ5a1VRWTI2cEhtQ3ZIS0p4SFhWWFlnQkdDNEpvalRmT3RwYWUzS1BKSFl5M3doS1BHeVlsdndjSU1YMnEzUjh2UkJhRGxyNC9VWGUwTmsxNEw3eVlTVVZOV2dPWkVnSVQvSDBDU3phUzhkSXRxZGpnd2NuTURwL3NCTyt0elNFRVZKODhaQVBYMjNsNlBmUjk0dUp2ZlgrSS92UDhvNTFCb1VPakJBSUgvcXoweWNDQ0ViUkowVGpXZjZRN1VSNTQ1Y05xOFk4VHBWRXlrenE5SWxRdUo0L0JrUmZyUnczZHk4cWNSMm55OFBwS2J5dk5pZ0VscTdJbi9jWmVIUkg1Mkw3Mm1RZFl0azArbitVS0h0TzcyMjRzVG1WL3FScnVSQVpXU0JqSlF4WmZ3Rks2anhPbHh6US9YME0rdlM3blRrVGFOa1E4ZEwyTzhIS0NrUnpnUlVTbEJrM2hva1ZnNzlVdWcwMlFvUE0vR21Ma3d2SVNrbFk3Z2VKTUlTMUYzc3VvR2VPMnlPT0VTMjBGQzlkMjBqYmwyandNYWxZb05IRUMyZHBmcDl5Y0VSNmZ0aHBIQ284cy82b2F0QkdDWXlGSFAxbDhTNnY5ZStnZlhjbEpFMGRjb0c4ODJjMmVyeVRnMWI2NmQ0bGh4RTdOZHU3N3VkMXd0WGo2VzJrai9MUHZETE1RUVhScklEaDh3Q2pIMXZud0k2NXlJOVZIbnMxV2JPUHpsWWZoZENlZks0WFVLSEJGdzZCSytybzlxLzVpbWt5ZDdhYTJ4Zm9CTVpMbjcrdVFmUGYwNzFxTnZLTHNsem0rQ0ZRNnk3Y0N5WVlUQk1TQ3J6TElUdGJzd2F2S1dCaVRmRnN1UysweFk3Ymo1QUxEQnR5eGZva2ZqemwvSDdIUVlLT1R0SGxaK1ZybHhaK2hwamJhSTZYZkFxVzRpMHkyRW4rU0lYSUc5cnlLTFd3V1VDV0R4L0ZuVlp4bGlPNThPREtjZ1R5WjVNdUszRE5uUHFDQ2VQV3h1ZVZBcFE4bGU2T2d5S1FnSTJJa3RnMm5SN0ZEeTRzRkw2L1hRYlN6VUR0YXhiSGk1b0tiUyt6YUZkdWpQSlloZTB2bExDZTlLdjZBekJJVnM0QWMzekl3V05GamtLc0g3alNHMmovenFpRWNwa2dqZ3VRN2dZSURNSlhMbkV0S3pqbmZ6aUEvRHhuZS80VnRubndadGtKQzRUdUhWWTNNcXQ4WFdVQ0dHcUhuajJEUm0rV0lsaG84NHBZNTdWVkpWYyt4aS9BL0tUeFNsV1lNT1hGREQ5RFBXVDFoZUt4b1RBQUpSQkpod1VtckNxUHFCVzhIWS9DcXZ1Vk9JWFl2aE5Ld2g1VnY1YVhTd25sTlZ5aFEvdXkvUWYzMjJsL293eXFuM0NENnNkUUVRMExkRlo3VDU5MmRFOEkwRDBMWjlaeWc2cW4xZmoxV0VEaWl3N1daeGVtUFg3dHI2dXVURHVPQ3VsWXEvTlNwL2lJUGoyQnFqWW8yVitGblNPNzNnWHFzVWV1enhnM3kycENKa0p5S2lwU0VxMzU2bEJGVE8vYmhNK0VZUm1pcE82eGNiYUlmdThTUVQ1eDVmcEZwdVF3M0Q0VjQvRWQ4VEtoanBMUkVqdlQwYlplREFUU3NEaWQxT2diOTVQUWVvMHd4UGtKMEQwdFlDamJsbzNQek5jUkRQQ3UvSFlhQWVuYUtkZ3NvU1MzQmdrS2xvQWNVc2pYcUtja09DUWZRSlRpYy9NdWhpVkNnbk9GYWdRbEVpbU1sMi9RVlEyd2htNkdvaDd1ZXAvRXVPdkMwUXBDMXJBb3pzdkdERG1vYzdPV09CRVBQS1JCY1hPMjRELzB1WDdoRG0xTXhmRmF3YXBnUVZ2L0ZhVmMwdHJObVFXWjRubHN3b1lVWG92M3lyQ1BpRXR3ZTR1MzFMbE55elFna1BsUHlYRGJ2UkN6ZlUzMVFZVmk2OHZaVFVUdlJwN1NxZU53R0ZRSEkvWWc4MkI5RFBMZFhLanU4aUNtVXhwby9Da2dHOTVlVmticFlMWGFBNkFsMjVwRzdWMjRaVml1WHJUaGFFdFMvSFR5UU4zZEduQVgvOHBsQ1ZOTklyYlI5WVFMQmRyQ1ZtcVgyNDlBVFlKVFQrZCthNFNVbmoxNFBXenIyaGcya2NVYTNONXIxWDYzWU54aGVLQWNMOFZ1Mld0SW10bVJ0RDZ5RjZqdTJZK0JtdDhtWDExa215NkNBRFlhSUVGL3NRaXJwTXpmQ25SU1VuYURJWGVMeGdvTHJQUUp6NitDR3EzUVpLcUxYQ2x6K0FXbFZSdS9BVEc4RDEzK0RqOXhNYzZhci9iMzFLZVJjN052VHFwMXA1VVVYcjlobWlYMS9hRnVUWHhRdTQ3UFB1MXd1U1QraGxWenQxY2hvZjc0V0V0NktzNm5td1ZVakJvL2pLSlRPTUF6aUpyM0VtcTdaY1JPNytVNVNRZFc1dm1UckxSZnl5WVFRYzE2Mlp4OEFlam1wVDNPd0ZyeDdjeGpPSHpmTlJJTWJzL2Rkam5JTWhEVUlxSE1KbEZmR0l6blNXVFZIR2JMTXNOSk5nQ1NWNXREL2RzMzdqWFByTkJFTFhRMWVaUG05QVZCVEIxNUJtWlZlUWpRNUh4czBUSDc0RER0REdXbVRsYWJ5WC9sbUdqclk1N3lyVVM0QWFuZ09tN2hxUjhpZng1ZmdzcEJKOUNkMlo0dVJPV3NScjE3OEJPU3U2UXRhc1grYzhCdEZsWlBEWHViVTBLVW5YeWE4ckhzSDNnV2Q5a0ZHVHpraWxXRy8yaW02eUhsUmVkQUg5dHdMRXlvQndKU0ZObHNlY1IvZnplVEYzUUxMWmJUaE1YTFdvc21RUGxvOGkvWUQzUllOOTlxVCt3ZU5HMHRscDhXNXFFT0laUEMvcnE4TlVnYUx6YXhUYUp5WjhIL3BQTGxWdDI4NVRmQ0p4d25jeXJJOFBteWRzcnNMTDdkN2toM1ZTRVZQRkNlSUVBQ2lBNE1KN1FKMVBUMlNmZXh2Qmx4bjhjN29Kd3l4dkQrLzlnTm1DMEltZlRhaHFhcUFjYWRoZk4xVzUxNXlFcXEwNFF4WkE1SUNzMGk1OUFUU2ZORFgwWHhmcXdLR3g4amkxeWx3cm5BRHpSS1ZIT2crT0xCRXlXODBuTFFGTEI4SnJiY2Q3UkpzYk9hL3NkZ09kMVJJUEtPcGViN0ZqNVlxZFE2SktlR2l3dFpNU0R3d3JZVlk0UzB4SXR2b3ZOZGN0UngrUDdHbkJLVzRqdXNCSnVRaHFiVWx3cHRrcDlTOG13aVFkMWZQaUl1REExbkJ5Y04zZWIxTG1yQUpLU2VkbUhJdGx4U2w2NXVZMm1KeXVhZGFHY25hTmRjc3MyaGZTYWJ0ZFJoMi5aZWVacjJkY1E1NDU3aFNQSUFPa2lqMWxDUWNmV3BVVUpJV1E1ekRyV1hNSDFRZDFtZUtfMnd1RTlWcEo2Nm1aVHpva25UMFYtR3NmcW5LV1MtVlh1dw==";

    final referer = 'https://myadmin.unisa.ac.za/student/portal/exam-results-app/search';
    final header = {
      'Referer': referer,
      //'Content-Type': 'application/json',
      'Accept-Charset': 'utf-8',
      'Accept': 'application/json'
    };

    Map<String, String> body = {
      "username": studentNumber,
      "password": password,
      "_eventId": "submit",
      "execution": execution
    };

    final data = convert.jsonEncode(body);
    //final request = Uri.encodeComponent(body);

    final res = await http.post(url, body: body,
        headers: header,
        encoding: convert.Encoding.getByName('utf-8'));

        print(res.body);

    if (res.statusCode == 302) {
      final my = res.headers['location'].toString();
      final getAuth = await http.post(my, headers: header);
      cookie =  getAuth.headers['set-cookie'].substring(0,45);
     // student = studentNumber;
      notifyListeners();
    }else{
      error = 'Please enter a valid studentNo and password ';
      notifyListeners();
    }

  }

  Future<String> studentId(String studentNum){
    student = studentNum;
    notifyListeners();
  }

}