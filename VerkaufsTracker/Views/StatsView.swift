//
//  StatsView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct StatsView: View {
	let verwaltung: Verwaltung
	var body: some View {
		VStack(alignment: .leading, spacing: 20){
			Text("Statistiken").font(.largeTitle.bold())
			HStack(spacing: 150){
				let wunschTickets = verwaltung.personen.map({$0.wuenschBestellungen[.ball_ticket] ?? 0}).reduce(0, +)
				
				VStack(alignment: .center){
					Text("Gewünschte Tickets").font(.title.bold())
					Pie(slices: [(Double(wunschTickets), .blue), (Double(Item.ball_ticket.verfuegbar-wunschTickets), .red)])
					VStack(alignment: .leading, spacing: 0){
						HStack(alignment: .center){
							Circle().fill(.blue).frame(width: 10, height: 10)
							Text("Belegte Tickets:")
							Spacer()
							Text("\(wunschTickets)/\(Item.ball_ticket.verfuegbar) (\((Int(Float(wunschTickets) / Float(Item.ball_ticket.verfuegbar)*100)))%)").bold()
						}
						HStack{
							Circle().fill(.red).frame(width: 10, height: 10)
							Text("Freie Tickets:")
							Spacer()
							Text("\(Item.ball_ticket.verfuegbar - wunschTickets)/\(Item.ball_ticket.verfuegbar) (\((Int(Float(Item.ball_ticket.verfuegbar-wunschTickets) / Float(Item.ball_ticket.verfuegbar)*100)))%)").bold()
						}
					}
				}
								
				let formSubmitted = verwaltung.personen.filter({$0.extraFields["hatFormEingetragen", default: ""] == "1"}).count
				
				VStack(alignment: .center){
					Text("Formular ausgefüllt").font(.title.bold())
					Pie(slices: [(Double(formSubmitted), .blue), (Double(verwaltung.personen.count-formSubmitted), .red)])
					VStack(alignment: .leading, spacing: 0){
						HStack(alignment: .center){
							Circle().fill(.blue).frame(width: 10, height: 10)
							Text("Formular ausgefüllt:")
							Spacer()
							Text("\(formSubmitted)/\(verwaltung.personen.count) (\((Int(Float(formSubmitted) / Float(verwaltung.personen.count)*100)))%)").bold()
						}
						HStack{
							Circle().fill(.red).frame(width: 10, height: 10)
							Text("Formular nicht ausgefüllt:")
							Spacer()
							Text("\(verwaltung.personen.count - formSubmitted)/\(verwaltung.personen.count) (\((Int(Float(verwaltung.personen.count-formSubmitted) / Float(verwaltung.personen.count)*100)))%)").bold()
						}
					}
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
