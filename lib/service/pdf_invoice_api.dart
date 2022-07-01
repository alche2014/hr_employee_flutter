import 'dart:io';
import 'package:hr_app/main.dart';
import 'package:hr_app/service/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfParagraphApi {
  static Future<File> generate(
    ImageProvider image,
    data,
  ) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(0),
        header: (context) {
          return Column(
            children: [
              Container(
                height: 40,
                color: const PdfColor.fromInt(0xFF1D1D35),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                      color: PdfColor.fromInt(0xFF1D1D35), thickness: 2),
                ),
              )
            ],
          );
        },
        build: (context) => <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: buildHeaderTitles(data, image)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: buildHeaderTitles2(data, image)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: buildTitles(data)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: buildEdu(data)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: buildTraining(data)),
          SizedBox(height: 5.9 * PdfPageFormat.cm),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
          return Stack(children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                  color: PdfColor.fromInt(0xFF1D1D35),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
              child: Text(
                text,
                style: const TextStyle(color: PdfColors.white),
              ),
            ),
          ]);
        },
      ),
    );
    return PdfApi.saveDocument(name: 'CV.pdf', pdf: pdf);
  }

  static Widget buildTitles(data) => Column(children: [
        data['trainings'] == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: training(data),
              ),
      ]);

  static Widget buildEdu(data) => Column(children: [
        data['education'] == null ? Container() : edu(data),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: buildPaidTables(data),
        ),
      ]);

  static Widget buildTraining(data) => Column(children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data['licenses'] == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: certificates(data),
                    ),
            ]),
      ]);

  static Widget buildPaidTables(data) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('SKILLS',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              ]),
              Container(
                padding: const EdgeInsets.only(left: 7, right: 7, top: 10),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        data['skills'] != null ? data['skills'].length : 0,
                    itemBuilder: (context, int index) {
                      return Wrap(
                          spacing: 10.0,
                          direction: Axis.horizontal,
                          runSpacing: 20.0,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data['skills'] == null
                                        ? "No Skills added Yet"
                                        : data['skills'][index],
                                    style: TextStyle(
                                        color: isdarkmode.value == false
                                            ? PdfColors.grey
                                            : PdfColors.grey,
                                        fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ]);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget certificates(data) {
    var courseDocument = data;
    data = courseDocument['licenses'];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('LICENSES & TRAININGS',
                  style: TextStyle(
                    color: const PdfColor.fromInt(0xFF1D1D35),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )),
            ]),
            Container(
              padding: const EdgeInsets.only(left: 2, right: 7, top: 10),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  itemBuilder: (context, int index) {
                    return Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 5),
                            child: Text(
                              data == null ? "Name" : data[index]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 5),
                            child: Text(
                              data[index]['type'] == "null"
                                  ? "Type"
                                  : data[index]['type'],
                              style: const TextStyle(
                                  color: PdfColors.grey, fontSize: 17),
                            ),
                          ),
                          // Container(
                          //     margin: const EdgeInsets.only(
                          //         top: 3, bottom: 6, left: 5),
                          //     child: Row(
                          //       children: [
                          //         Text(
                          //             data[index]['startDate'] == null
                          //                 ? "Date"
                          //                 : data[index]['startDate'],
                          //             style: const TextStyle(
                          //                 color: PdfColors.grey, fontSize: 17)),
                          //         Text(' - '),
                          //         Text(
                          //             data[index]['lastDate'] == null
                          //                 ? "Date"
                          //                 : data[index]['lastDate'],
                          //             style: const TextStyle(
                          //                 color: PdfColors.grey, fontSize: 17))
                          //       ],
                          //     ))
                        ]));
                  }),
            ),
          ],
        ));
  }

  static Widget training(data) {
    var courseDocument = data;
    data = courseDocument['trainings'];

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('TRAININGS',
                  style: TextStyle(
                    color: const PdfColor.fromInt(0xFF1D1D35),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )),
            ]),
            Container(
              padding: const EdgeInsets.only(left: 2, right: 7, top: 10),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  itemBuilder: (context, int index) {
                    return Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 5),
                            child: Text(
                              data == null ? "Name" : data[index]['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 3, bottom: 3, left: 5),
                            child: Text(
                              data[index]['type'] == "null"
                                  ? "Type"
                                  : data[index]['type'],
                              style: const TextStyle(
                                  color: PdfColors.grey, fontSize: 17),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 3, bottom: 6, left: 5),
                              child: Row(
                                children: [
                                  Text(data[index]['expstartDate'] ?? "Date",
                                      style: const TextStyle(
                                          color: PdfColors.grey, fontSize: 17)),
                                  Text(' - '),
                                  Text(data[index]['expLastDate'] ?? "Date",
                                      style: const TextStyle(
                                          color: PdfColors.grey, fontSize: 17))
                                ],
                              ))
                        ]));
                  }),
            ),
          ],
        ));
  }
}

Widget about(snapshot) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text('ABOUT ME',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ]),
        Container(
            alignment: Alignment.topLeft,
            child: Text(
              snapshot["aboutYou"] ?? "",
              style: const TextStyle(color: PdfColors.grey, fontSize: 17),
            ))
      ]));
}

Widget experience(snapshot) {
  var courseDocument = snapshot;
  var workexp = courseDocument['workExperience'];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('EXPERIENCE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ]),
        Container(
          padding: const EdgeInsets.only(left: 2, right: 7, top: 10),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: workexp.length,
              itemBuilder: (context, int index) {
                var dateto = workexp[index]['expLastDate'] == "" ||
                        workexp[index]['expLastDate'] == null
                    ? ""
                    : workexp[index]['expLastDate'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 3),
                      child: Text(
                        workexp == null ? "Title" : workexp[index]['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 4, bottom: 3, left: 5),
                        child: Row(
                          children: [
                            Text(
                              workexp[index]['companyName'] == ""
                                  ? "Company Name"
                                  : workexp[index]['companyName'],
                              style: const TextStyle(
                                  color: PdfColors.grey, fontSize: 17),
                            ),
                            Text(" - "),
                            Text(
                              workexp[index]['empStatus'] == null
                                  ? "Status"
                                  : workexp[index]['empStatus'],
                              style: TextStyle(
                                  color: PdfColors.grey, fontSize: 17),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 3, bottom: 6, left: 5),
                      child: Text(
                        dateto == ""
                            ? workexp[index]['expstartDate']
                            : workexp[index]['expstartDate'] == null
                                ? "Date"
                                : workexp[index]['expstartDate'] +
                                    " - " +
                                    dateto,
                        style: const TextStyle(
                            color: PdfColors.grey, fontSize: 17),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    ),
  );
}

Widget edu(snapshot) {
  var courseDocument = snapshot;
  var edu = snapshot['education'];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('EDUCATION',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ]),
        Container(
          padding: const EdgeInsets.only(left: 2, right: 7, top: 10),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: edu.length,
              itemBuilder: (context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 3),
                      child: Text(
                        edu == null ? "School" : edu[index]['school'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 4, bottom: 3, left: 5),
                        child: Row(
                          children: [
                            Text(
                              edu == null ? "Degree" : edu[index]['degree'],
                              style: const TextStyle(
                                  color: PdfColors.grey, fontSize: 17),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 3, bottom: 6, left: 5),
                      child: Text(
                        edu == null
                            ? "Years "
                            : (edu[index]['expstartDate'] +
                                " - " +
                                edu[index]['expLastDate']),
                        style: const TextStyle(
                            color: PdfColors.grey, fontSize: 17),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    ),
  );
}

Widget personalInfo(snapshot) {
  return Container(
    padding: const EdgeInsets.only(bottom: 5, left: 5, top: 10, right: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "Email: ",
                  style: TextStyle(
                      color: const PdfColor.fromInt(0xFF1D1D35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["otherEmail"] == "" || snapshot["otherEmail"] == null
                      ? "Email"
                      : snapshot["otherEmail"],
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "Phone: ",
                  style: TextStyle(
                      color: const PdfColor.fromInt(0xFF1D1D35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["phone"] ?? "Phone",
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "City: ",
                  style: TextStyle(
                      color: const PdfColor.fromInt(0xFF1D1D35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["cityName"] ?? "City",
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "Blood Group: ",
                  style: TextStyle(
                      color: const PdfColor.fromInt(0xFF1D1D35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["bloodGroup"] ?? "Blood Group",
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "Address: ",
                  style: TextStyle(
                      color: const PdfColor.fromInt(0xFF1D1D35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["address"] ?? "Address",
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    "CNIC: ",
                    style: TextStyle(
                        color: PdfColor.fromInt(0xFF1D1D35),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  snapshot["cnic"] == null || snapshot["cnic"] == ""
                      ? "CNIC"
                      : snapshot["cnic"],
                  style: TextStyle(
                      color: PdfColors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildHeaderTitles(data, image) => Column(children: [
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: image, fit: BoxFit.fill),
            ),
          ),
          SizedBox(width: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Paragraph(
                padding: const EdgeInsets.only(left: 15),
                text: empName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Paragraph(
                padding: const EdgeInsets.only(left: 15),
                text: data["designation"] == null || data["designation"] == ""
                    ? "Designation"
                    : data["designation"],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: personalInfo(data)),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: about(data)),
    ]);
Widget buildHeaderTitles2(data, image) => Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: experience(data),
      ),
    ]);

String returnMonth(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
