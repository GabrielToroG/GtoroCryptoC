//
//  ContentView.swift
//  Crypto
//
//  Created by Gabriel Toro on 10/04/2022.
//

import SwiftUI
import UserNotifications

struct CryptoView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        ZStack{
            //Changing Between Views
            if currentPage == 1{
                Screen1(title: "gtoroCrypto", detail: "Aplicación para visualizar el valor de las 10 criptomonedas con mayor valor actualmente", bgColor: Color("Primary"))
                    .transition(.scale)
            }
            if currentPage == 2{
                Screen2(viewModel: CryptoViewModel())
                    .transition(.scale)
            }
            
        }
        .overlay(
            Button(action: {
                //changin views
                withAnimation(.easeInOut){
                    if currentPage < totalPages{
                        currentPage += 1
                    }
                    else{
                        currentPage = 1
                    }
                }
            },label:{
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .clipShape(Circle())
            })
            ,alignment: .bottom
        )
        .onAppear{  //cada vez que se mire la pantalla, se borran las notifiaciones rojas
            NotificationManager.instance.requestAuthorization()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}




struct Screen1: View{
    var title: String
    var detail: String
    var bgColor: Color
    
    var body: some View{
        VStack(spacing: 20){
            HStack{
                Text("Gabriel Toro")
                    .font(.title)
                    .fontWeight(.semibold)
                    .kerning(1.4)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            
            //Deja todo arriba
            Spacer(minLength: 0)
            
            Image("Image")
                .resizable(resizingMode: .stretch)
                .frame(width: 320.0, height: 350.0)
                
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, -11.0)
                
            Text(detail)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 4.0)
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

struct Screen2: View{
    @ObservedObject var viewModel: CryptoViewModel
    @State var textFieldText: String = ""
    @State var limit: Int = 0
    var body: some View {
        VStack(spacing: 10){
            HStack{
                TextField("Límite Bitcoin", text: $textFieldText)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: 260.0, height: 50.0)
                    .background(Color.white.opacity(1).cornerRadius(20))
                    .font(.headline)
                    .keyboardType(.phonePad)
                
                
                Button{
                    saveText()
                    if(Int(viewModel.BTCNotification.price) > limit){
                        NotificationManager.instance.scheduleNotification(price: limit)
                    }
                } label: {
                    Text("Fijar valor")
                }
            }

            
            //Deja todo arriba
            Spacer(minLength: 0)
            
            List{
                ForEach(viewModel.cryptos.enumerated().map({$0}).prefix(10), id: \.element.name){ inde, item in
                    HStack{
                        Text("\(inde+1)")
                        Text(item.name)
                        Text(item.symbol)
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                            
                    }
                    .padding(10.0)
                    .foregroundColor(.black)
                }
                .padding(.bottom, 7.0)
                .listRowSeparatorTint(Color("Secundary"))
            }
            .onAppear(perform: viewModel.onAppear)
            .listStyle(.plain)
                        
        }
        .background(Color("Secundary").cornerRadius(10).ignoresSafeArea())
    }
    func saveText(){
            limit = Int(textFieldText) ?? 0
            print(limit)
    }
}

var totalPages = 2



class NotificationManager{
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options){ success, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success")
            }
        }
    }
    
    func scheduleNotification(price:Int){
        let content = UNMutableNotificationContent()
        content.title = "¡Finalmente!"
        content.subtitle = "El bitcoin supero el precio de $\(price)"
        content.sound = .default
        content.badge = 1
        
        //time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cancelNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            
    }
}


struct Previews_CryptoView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoView(viewModel: CryptoViewModel())
    }
}
