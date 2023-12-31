//
//  StatsView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI
#if canImport(Charts)
import Charts

struct StatsView: View {
	let verwaltung: Verwaltung
	@State var einlassMode = false
	
	var body: some View {
		VStack(spacing: 30){
			Text("Statistiken").font(.largeTitle.weight(.heavy))
				.onLongPressGesture {
					einlassMode.toggle()
				}
			if einlassMode {
				EinlassStatsView(verwaltung: verwaltung)
			} else {
				if #available(iOS 16, *) {
					if UIDevice.current.userInterfaceIdiom == .phone{
						ScrollView(showsIndicators: false){
							VStack(spacing: 15){
								StatsViewComponents(verwaltung: verwaltung)
							}
						}
					} else {
						ScrollView(showsIndicators: false){
							Spacer()
							HStack{
								StatsViewComponents(verwaltung: verwaltung)
							}
							Spacer()
						}
					}
				} else {
					Text("in der iOS Version nicht verfügbar")
				}
			}

		}.padding()
	}
}

struct Groese: Identifiable {
	var name: String
	var betrag: Int
	var id = UUID()
}


@available(macCatalyst 16.0, *)
@available(iOS 16.0, *)
struct StatsViewComponents: View{
	let verwaltung: Verwaltung
	var body: some View{
		VStack{
			Text("Verteilung").font(.title.bold())

			TabView{
				WunschPieCharts(verwaltung: verwaltung).padding(.bottom, 30)
				VStack{
					Text("Pulligrößen und Buch").font(.title2.bold())
					Chart {
						let data: [Groese] = [
							.init(name: "XS", betrag: verwaltung.personen.compactMap({Int($0.extraFields[.pulli_xs, default: "0"]) ?? 0}).reduce(0, +)),
							.init(name: "S", betrag: verwaltung.personen.compactMap({Int($0.extraFields[.pulli_s, default: "0"]) ?? 0}).reduce(0, +)),
							.init(name: "M", betrag: verwaltung.personen.compactMap({Int($0.extraFields[.pulli_m, default: "0"]) ?? 0}).reduce(0, +)),
							.init(name: "L", betrag: verwaltung.personen.compactMap({Int($0.extraFields[.pulli_l, default: "0"]) ?? 0}).reduce(0, +)),
							.init(name: "XL", betrag: verwaltung.personen.compactMap({Int($0.extraFields[.pulli_xl, default: "0"]) ?? 0}).reduce(0, +)),
						]
						ForEach(data) { pos in
							BarMark(
								x: .value("Shape Type", pos.name),
								y: .value("Total Count", pos.betrag)
							)
						}
					}.frame(height: 300)
					VStack(spacing : 0){
						HStack{
							Circle().fill(.blue).frame(width: 10, height: 10)
							Text("Pulli")
							Spacer()
							Text("\(verwaltung.personen.map({$0.wuenschBestellungen[.pulli] ?? 0}).reduce(0, +))")
						}
						HStack{
							Circle().fill(.cyan).frame(width: 10, height: 10)
							Text("Buch")
							Spacer()
							Text("\(verwaltung.personen.map({$0.wuenschBestellungen[.buch] ?? 0}).reduce(0, +))")
						}
					}
					Spacer()
				}.frame(height: 350)
			}.tabViewStyle(PageTabViewStyle())
				.frame(height: 450)
		}
		
		Divider()

		VStack{
			Text("Prozess").font(.title.bold())
			TabView{
				SendCharts(verwaltung: verwaltung).padding(.bottom, 30)
			}.tabViewStyle(PageTabViewStyle())
				.frame(height: 450)
		}

		Divider()
		
		VStack{
			Text("Zahlungen").font(.title.bold())
			TabView{
				BestellungenPieCharts(verwaltung: verwaltung).padding(.bottom, 30)
			}.tabViewStyle(PageTabViewStyle())
				.frame(height: 450)
		}
	}
}

struct WunschPieCharts: View{
	let verwaltung: Verwaltung
	var body: some View{
//		let formSubmitted = verwaltung.personen.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"}).count
//		PieChart(title: "Formularteilnahme", statement: "Formular ausgefüllt", counterStatement: "Formular ausstehend", value: formSubmitted, capacityValue: verwaltung.personen.count)

		let bestellungenTickets = verwaltung.personen.map({$0.bestellungen[.ball_ticket] ?? 0}).reduce(0, +)
        let externe = verwaltung.personen.filter({$0.formID == "E7EN5"}).first
        
        
        PieChart(title: "Ball-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: bestellungenTickets + (externe?.tickets.filter({$0.itemType == .ball_ticket}).count ?? 0), capacityValue: Item.ball_ticket.verfuegbar)

		let bestellungenTicketsASP = verwaltung.personen.map({$0.bestellungen[.after_show_ticket] ?? 0}).reduce(0, +)
		PieChart(title: "ASP-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: bestellungenTicketsASP + (externe?.tickets.filter({$0.itemType == .after_show_ticket}).count ?? 0), capacityValue: Item.after_show_ticket.verfuegbar)
		/*
		 PIE CHARTS
		 let wunschBuch = verwaltung.personen.map({$0.wuenschBestellungen[.buch] ?? 0}).reduce(0, +)
		 PieChart(title: "Buch", statement: "Reserviert", counterStatement: "Frei", value: wunschBuch, capacityValue: Item.buch.verfuegbar)

		 let wunschPulli = verwaltung.personen.map({$0.wuenschBestellungen[.pulli] ?? 0}).reduce(0, +)
		 PieChart(title: "Pulli", statement: "Reserviert", counterStatement: "Frei", value: wunschPulli, capacityValue: Item.pulli.verfuegbar)
		 */
	}
}


struct SendCharts: View{
	let verwaltung: Verwaltung
	var body: some View{
		let formEmailSend = verwaltung.personen.filter({$0.extraFields[.sendFormEmail, default: ""] == "1"}).count
		PieChart(title: "Formular E-Mail-Sendestatus", statement: "Gesendet", counterStatement: "Nicht gesendet", value: formEmailSend, capacityValue: verwaltung.personen.count)

		let formSubmitted = verwaltung.personen.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"}).count
		PieChart(title: "Formularteilnahme", statement: "Formular ausgefüllt", counterStatement: "Formular ausstehend", value: formSubmitted, capacityValue: formEmailSend)

		let bezahlSend = verwaltung.personen.filter({$0.extraFields[.sendBezahlEmail, default: ""] == "1"}).count
		PieChart(title: "Bezahlübersicht E-Mail-Sendestatus", statement: "Gesendet", counterStatement: "Nicht gesendet", value: bezahlSend, capacityValue: formSubmitted)

		let bezahlt = verwaltung.gezahltePersonen
		PieChart(title: "Vollständig gezahlte Personen", statement: "Gezahlt", counterStatement: "Ausstehend", value: bezahlt, capacityValue: bezahlSend)

		let generiert = verwaltung.personen.filter({!$0.tickets.isEmpty && $0.tickets.count == ($0.bestellungen[.ball_ticket, default: 0] + $0.bestellungen[.after_show_ticket, default: 0])}).count
        PieChart(title: "Vollständig für Personen generiert ", statement: "Voll generiert", counterStatement: "Nicht voll generiert", value: generiert, capacityValue: bezahlt)

		let ticketSend = verwaltung.personen.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"}).count //<- AENDERUNG BEI TICKET-FERTIGSTELLUNG
		PieChart(title: "Ticket E-Mail-Sendestatus", statement: "Gesendet", counterStatement: "Nicht gesendet", value: generiert, capacityValue: bezahlt)
	}
}

struct BestellungenPosition: Identifiable {
	var name: String
	var betrag: Double
	var id = UUID()
	var color: String
}

@available(macCatalyst 16.0, *)
@available(iOS 16.0, *)
struct BestellungenPieCharts: View{
	let verwaltung: Verwaltung


	var anzahlBestellungGeld: Int{
		verwaltung.offenerBetrag + verwaltung.insgGezahlt - verwaltung.zuVielGezahlt
	}


	var body: some View{
		VStack{
			Text("Beträge").font(.title2.bold())
			Chart {
				let data: [BestellungenPosition] = [
					.init(name: "Bezahlung/Spende", betrag: Double(verwaltung.insgGezahlt - verwaltung.zuVielGezahlt) / 100, color: "Bezahlung"),
					.init(name: "Bezahlung/Spende", betrag: Double(verwaltung.zuVielGezahlt) / 100, color: "Spende"),
					.init(name: "Offen/Beglichen", betrag: Double(verwaltung.insgGezahlt - verwaltung.zuVielGezahlt) / 100, color: "Beglichen"),
					.init(name: "Offen/Beglichen", betrag: Double(verwaltung.offenerBetrag) / 100, color: "Offen"),
				]
				ForEach(data) { pos in
					BarMark(
						x: .value("Shape Type", pos.name),
						y: .value("Total Count", pos.betrag)
					)
					.foregroundStyle(by: .value("Beschreibung", pos.color))
				}
			}.chartForegroundStyleScale([
				"Bezahlung": .blue, "Spende": .purple, "Offen": .red, "Beglichen": .green
			])
            VStack{
                Text("Bezahlt: " + "\(((verwaltung.insgGezahlt - verwaltung.zuVielGezahlt)/100).formatted(.currency(code: "EUR")))")
                Text("Offen: " + "\((verwaltung.offenerBetrag/100).formatted(.currency(code: "EUR")))")
            }
            .padding()
		}

		PieChart(title: "Vollständig gezahlte Personen", statement: "Gezahlt", counterStatement: "Ausstehend", value: verwaltung.gezahltePersonen, capacityValue: verwaltung.personenMitBestellung)
	}
}

struct PieChart: View{
	let title: String
	let statement: String
	let counterStatement: String
	let value: Int
	let capacityValue: Int
	
	var statementPercentage: String {
		let v = Float(value)
		let cV = Float(capacityValue)
		var percentage = v/cV * 100
		if percentage < 0{percentage = 0}
		let string = String(format: "%0.1f",percentage)
		return string
	}
	
	var counterStatementPercentage: String {
		let v = Float(capacityValue-value)
		let cV = Float(capacityValue)
		var percentage = v/cV * 100
		if percentage < 0{percentage = 0}
		let string = String(format: "%0.1f",percentage)
		return string
	}
	
	var counterLabel: String {
		let x = capacityValue - value
		if x <= 0{
			return "Keine"
		} else {
			return "\(capacityValue - value)/\(capacityValue) (\(counterStatementPercentage)%)"
		}
	}
	
	var body: some View{
		VStack(alignment: .center){
			Text(title).font(.title2.bold()).multilineTextAlignment(.center)
			Pie(slices: [(Double(value), .blue, Double(statementPercentage)), (Double(capacityValue-value), .red, Double(counterStatementPercentage))])
			VStack(alignment: .leading, spacing: 0){
				HStack(alignment: .center){
					Circle().fill(.blue).frame(width: 10, height: 10)
					Text(statement)
					Spacer()
					Text("\(value)/\(capacityValue) (\(statementPercentage)%)").bold()
				}
				HStack{
					Circle().fill(.red).frame(width: 10, height: 10)
					Text(counterStatement)
					Spacer()
					Text(counterLabel).bold()
				}
			}
		}.padding()
	}
}


struct Pie: View {

	@State var slices: [(Double, Color, Double?)]

	var body: some View {
		Canvas { context, size in
			let total = slices.reduce(0) { $0 + $1.0 }
			context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
			var pieContext = context
			pieContext.rotate(by: .degrees(-90))
			let radius = min(size.width, size.height) * 0.48
			var startAngle = Angle.zero
			var reached100 = false
			for (value, color, percentage) in slices {
				if percentage ?? 0 >= 100{
					reached100 = true
					let angle = Angle(degrees: 360)
					let endAngle = startAngle + angle
					let path = Path { p in
						p.move(to: .zero)
						p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
						p.closeSubpath()
					}
					pieContext.fill(path, with: .color(color))
				} else {
					if !reached100{
						let angle = Angle(degrees: 360 * (value / total))
						let endAngle = startAngle + angle
						let path = Path { p in
							p.move(to: .zero)
							p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
							p.closeSubpath()
						}
						pieContext.fill(path, with: .color(color))
						startAngle = endAngle
					}
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
	}
}
#else

struct StatsView: View {
	let verwaltung: Verwaltung
	var body: some View {
		Text("Statistiken nicht verfügbar")
	}
}
#endif
