import SwiftUI


struct UPRegContentView: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()

                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)



                    Text("Sign In")
                        .foregroundColor(Color.black.opacity(0.4))

                    TextField("Enter username", text: $username)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)
                    TextField("Enter password", text: $password)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .padding(.vertical)

                    PrimaryButton(title: "Sign In")
                    Button("Login"){}
                }

                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                Text("Read our Terms & Conditions.")
                    .foregroundColor(Color("PrimaryColor"))
                Spacer()

            }
            .padding()
        }
    }
}

//extension UPRegContentView{
//    func callLoginApi(params: [String : Any]){
////        print(params)
////
//////        showLoader()
//        APIService.shared.loginApi(params: params) {  (response, error) in
////            self?.removeLoader()
////            print(response)
//            if let status = response["status"] as? Int , status == 200{
////                let userAdd : [String:Any] = response["address"] as! [String : Any]
//
//            }
//            else if let status = response["status"] as? Int , status > 400 && status < 410{
////                self?.showAlertController(message: response["error"] as? String)
//            }
//            else{
////                self?.showAlertController(message: response["message"] as? String)
//            }
//        }
//    }
//}
struct LabelTextField: View {
    var label: String
    var placeHolder: String
    @State private var name = ""
    var body: some View {

        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField("Enter your name", text: $name)
                .padding(.all)
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
            }
            .padding(.horizontal, 15)
    }
}
