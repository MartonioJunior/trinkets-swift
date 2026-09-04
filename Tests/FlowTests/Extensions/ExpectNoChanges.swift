//
//  ExpectNoChanges.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/09/2026.
//

import CustomDump
import IssueReporting

public func expectNoChanges<T: Equatable>(
    _ expression: @autoclosure @escaping () throws -> T,
    changes updateExpectingResult: (inout T) throws -> Void,
    _ message: @autoclosure () -> String? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) {
    do {
        let expression1 = try expression()
        var expression2 = expression1
        try updateExpectingResult(&expression2)
        expectNoDifference(expression1, expression2, message(), fileID: fileID, filePath: filePath, line: line, column: column)
    } catch {
        reportIssue(
            error,
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
    }
}
