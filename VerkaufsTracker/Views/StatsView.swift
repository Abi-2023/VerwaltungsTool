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
	
	let rowPhone: [GridItem] = Array(repeating: GridItem(), count: 1)
    let columnStandard: [GridItem] = Array(repeating: GridItem(), count: 3)
	
	var body: some View {
		ScrollView(showsIndicators: false){
            VStack(spacing: 30){
                Text("Statistiken").font(.largeTitle.weight(.heavy))
                
                VStack(spacing: 15){
                    Text("Google-Formular").font(.title.bold())
                    
                    if UIDevice.current.userInterfaceIdiom == .phone{
                        TabView{
                            WunschPieCharts(verwaltung: verwaltung).padding(.bottom, 30)
                            VStack{
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
                                Spacer()
                            }
                        }.tabViewStyle(PageTabViewStyle())
                            .frame(height: 450)
                    } else {
                        LazyVGrid(columns: columnStandard){
                            WunschPieCharts(verwaltung: verwaltung)
                        }
                        VStack(spacing: 0){
                            HStack{
                                Circle().fill(.blue).frame(width: 10, height: 10)
                                Text("Pulli: \(verwaltung.personen.map({$0.wuenschBestellungen[.pulli] ?? 0}).reduce(0, +))")
                            }
                            
                            HStack{
                                Circle().fill(.cyan).frame(width: 10, height: 10)
                                Text("Buch: \(verwaltung.personen.map({$0.wuenschBestellungen[.buch] ?? 0}).reduce(0, +))")
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack(spacing: 15){
                    Text("Bestellungen").font(.title.bold())
                    
                    if UIDevice.current.userInterfaceIdiom == .phone{
                        TabView{
                            BestellungenPieCharts(verwaltung: verwaltung).padding(.bottom, 30)
                        }.tabViewStyle(PageTabViewStyle())
                            .frame(height: 450)
                    } else {
                        LazyVGrid(columns: columnStandard){
                            BestellungenPieCharts(verwaltung: verwaltung)
                        }
                    }
                }
            }
		}.padding()
	}
}

struct WunschPieCharts: View{
    let verwaltung: Verwaltung
    var body: some View{
        let formSubmitted = verwaltung.personen.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"}).count
        PieChart(title: "Formularteilnahme", statement: "Formular ausgefüllt", counterStatement: "Formular ausstehend", value: formSubmitted, capacityValue: verwaltung.personen.count)
        
        let wunschTickets = verwaltung.personen.map({$0.wuenschBestellungen[.ball_ticket] ?? 0}).reduce(0, +)
            PieChart(title: "Ball-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: wunschTickets, capacityValue: Item.ball_ticket.verfuegbar)
            
        let wunschTicketsASP = verwaltung.personen.map({$0.wuenschBestellungen[.after_show_ticket] ?? 0}).reduce(0, +)
        PieChart(title: "ASP-Tickets", statement: "Belegte Tickets", counterStatement: "Freie Tickets", value: wunschTicketsASP, capacityValue: Item.after_show_ticket.verfuegbar)
        /*
         PIE CHARTS
         let wunschBuch = verwaltung.personen.map({$0.wuenschBestellungen[.buch] ?? 0}).reduce(0, +)
         PieChart(title: "Buch", statement: "Reserviert", counterStatement: "Frei", value: wunschBuch, capacityValue: Item.buch.verfuegbar)

         let wunschPulli = verwaltung.personen.map({$0.wuenschBestellungen[.pulli] ?? 0}).reduce(0, +)
         PieChart(title: "Pulli", statement: "Reserviert", counterStatement: "Frei", value: wunschPulli, capacityValue: Item.pulli.verfuegbar)
         */
    }
}

struct BestellungenPieCharts: View{
    let verwaltung: Verwaltung
    
    var anzahlGezahlterPersonen: Int {
        var array: [Person] = []
        for person in verwaltung.personen{
            if person.zuzahlenderBetrag != 0 && person.offenerBetrag(v: verwaltung) == 0{
                array.append(person)
            }
        }
        return array.count
    }
    
    var anzahlBestellungPersonen: Int {
        var array: [Person] = []
        for person in verwaltung.personen{
            if person.zuzahlenderBetrag != 0{
                array.append(person)
            }
        }
        return array.count
    }
    
    var anzahlGezahltGeld: Int{
        var summe: Int = 0
        for person in verwaltung.personen{
            summe += person.gezahlterBetrag(v: verwaltung)
        }
        return summe / 100
    }
    
    var anzahlBestellungGeld: Int{
        var summe: Int = 0
        for person in verwaltung.personen{
            summe += person.zuzahlenderBetrag
        }
        return summe / 100
    }
    
    
    var body: some View{
        PieChart(title: "Gezahlt/Bestellungen (Betrag)", statement: "Gezahlt", counterStatement: "Ausstehend", value: anzahlGezahltGeld, capacityValue: anzahlBestellungGeld)
        
        PieChart(title: "Vollständig gezahlte Personen", statement: "Gezahlt", counterStatement: "Ausstehend", value: anzahlGezahlterPersonen, capacityValue: anzahlBestellungPersonen)
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
					Text("\(capacityValue - value)/\(capacityValue) (\(counterStatementPercentage)%)").bold()
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
