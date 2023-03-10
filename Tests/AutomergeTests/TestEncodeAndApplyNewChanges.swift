import Automerge
import XCTest

class EncodeAndApplyNewChangesTestCase: XCTestCase {
    func testEncodeAndApplyNew() {
        let doc = Document()
        try! doc.put(obj: ObjId.ROOT, key: "key1", value: .String("one"))

        let doc2 = Document()
        let changes1 = doc.encodeNewChanges()
        try! doc2.applyEncodedChanges(encoded: changes1)
        XCTAssertEqual(try! doc2.get(obj: ObjId.ROOT, key: "key1")!, .Scalar(.String("one")))

        try! doc.put(obj: ObjId.ROOT, key: "key1", value: .String("two"))
        let changes2 = doc.encodeNewChanges()
        try! doc2.applyEncodedChanges(encoded: changes2)
        XCTAssertEqual(try! doc2.get(obj: ObjId.ROOT, key: "key1")!, .Scalar(.String("two")))
    }

    func testEncodeAndApplyChangesSince() {
        let doc = Document()
        try! doc.put(obj: ObjId.ROOT, key: "key1", value: .String("one"))
        let doc2 = doc.fork()

        let heads = doc.heads()

        try! doc.put(obj: ObjId.ROOT, key: "key1", value: .String("two"))

        let changes = try! doc.encodeChangesSince(heads: heads)
        try! doc2.applyEncodedChanges(encoded: changes)
        XCTAssertEqual(try! doc2.get(obj: ObjId.ROOT, key: "key1")!, .Scalar(.String("two")))
    }
}
