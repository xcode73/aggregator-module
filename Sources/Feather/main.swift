//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

import CommonModule
import SystemModule
import UserModule
import ApiModule
import AdminModule
import FrontendModule

import AggregatorModule

Feather.metadataDelegate = FrontendMetadataDelegate()

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let feather = try Feather(env: env)
defer { feather.stop() }

feather.useSQLiteDatabase()
feather.useLocalFileStorage()
feather.usePublicFileMiddleware()

try feather.configure([
    CommonBuilder(),
    SystemBuilder(),
    UserBuilder(),
    ApiBuilder(),
    AdminBuilder(),
    FrontendBuilder(),
    
    AggregatorBuilder()
])

if feather.app.isDebug {
    try feather.resetPublicFiles()
}

try feather.start()

