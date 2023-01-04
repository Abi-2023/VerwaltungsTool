//
//  StatsView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI
import Charts

struct StatsView: View {
	let verwaltung: Verwaltung
	
	let column: [GridItem] = Array(repeating: GridItem(), count: 3)
	
	var body: some View {
		ScrollView(showsIndicators: false){
			VStack(spacing: 30){
				Text("Statistiken").font(.largeTitle.weight(.heavy))
				Text("Google-Formular").font(.title.bold())
				LazyVGrid(columns: column){
					let wunschTickets = verwaltung.personen.map({$0.wuenschBestellungen[.ball_ticket] ?? 0}).reduce(0, +)
					PieChart(title: "Ball-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: wunschTickets, capacityValue: Item.ball_ticket.verfuegbar)
					
					let wunschTicketsASP = verwaltung.personen.map({$0.wuenschBestellungen[.after_show_ticket] ?? 0}).reduce(0, +)
					PieChart(title: "ASP-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: wunschTicketsASP, capacityValue: Item.after_show_ticket.verfuegbar)
					
					let wunschTicketsBuch = verwaltung.personen.map({$0.wuenschBestellungen[.buch] ?? 0}).reduce(0, +)
					PieChart(title: "Buch", statement: "Reserviert", counterStatement: "Frei", value: wunschTicketsBuch, capacityValue: Item.buch.verfuegbar)
					
					let wunschTicketsPulli = verwaltung.personen.map({$0.wuenschBestellungen[.pulli] ?? 0}).reduce(0, +)
					PieChart(title: "Pulli", statement: "Reserviert", counterStatement: "Frei", value: wunschTicketsPulli, capacityValue: Item.pulli.verfuegbar)
						
					let formSubmitted = verwaltung.personen.filter({$0.extraFields["hatFormEingetragen", default: ""] == "1"}).count
					PieChart(title: "Formularteilnahme", statement: "Formular ausgefüllt", counterStatement: "Formular ausstehend", value: formSubmitted, capacityValue: verwaltung.personen.count)
				}
			}
		}.padding()
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
		let percentage = v/cV * 100
		let string = String(format: "%0.1f",percentage)
		return string
	}
	
	var counterStatementPercentage: String {
		let v = Float(capacityValue-value)
		let cV = Float(capacityValue)
		let percentage = v/cV * 100
		let string = String(format: "%0.1f",percentage)
		return string
	}
	
	var body: some View{
		VStack(alignment: .center){
			Text(title).font(.title2.bold())
			Pie(slices: [(Double(value), .blue), (Double(capacityValue-value), .red)])
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
					Text("\(capacityValue - value)/\(capacityValue) (\(counterStatementPercentage)%)").bold()
				}
			}
		}.padding()
	}
}


struct Pie: View {

    @State var slices: [(Double, Color)]

    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
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
        .aspectRatio(1, contentMode: .fit)
    }
}
