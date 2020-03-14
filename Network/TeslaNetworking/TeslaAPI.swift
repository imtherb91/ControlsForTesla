//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation

struct TeslaAPI {
    static let baseUrl: String = "https://owner-api.teslamotors.com"
    static let clientID: String = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
    static let clientSecret: String = "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
}

struct VehiclesListRequest: NetworkRequest {
    
}

struct VehiclesListResponse: NetworkResponse, Identifiable {
    let id: String
    let vehicle_id: String
    let vin: String
    let display_name: String
    let option_codes: String
    let color: String
    let state: String
    /*
     "response": [
       {
         "id": :id,
         "vehicle_id": :vehicle_id,
         "vin": ":vin",
         "display_name": ":name",
         "option_codes": "AD15,AF02,AH00,APF0,APH2,APPA,AU00,BCMB,BP00,BR00,BS00,BTX4,CC02,CDM0,CH05,COUS,CW02,DRLH,DSH7,DV4W,FG02,FR01,GLFR,HC00,HP00,IDBO,INBPB,IX01,LP01,LT3B,MDLX,ME02,MI02,PF00,PI01,PK00,PMBL,QLPB,RCX0,RENA,RFPX,S02B,SP00,SR04,ST02,SU01,TIC4,TM00,TP03,TR01,TRA1,TW01,UM01,USSB,UTAB,WT20,X001,X003,X007,X011,X014,X021,X025,X026,X028,X031,X037,X040,X042,YFFC,SC05",
         "color": null,
         "tokens": [
           ":token1",
           ":token2"
         ],
         "state": "online",
         "in_service": null,
         "id_s": ":ids",
         "calendar_enabled": true,
         "backseat_token": null,
         "backseat_token_updated_at": null
       }
     ],
     "count": 1
     */
}
