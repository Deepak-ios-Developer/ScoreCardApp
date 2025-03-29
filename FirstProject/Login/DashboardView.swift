import SwiftUI

struct Team: Identifiable {
    let id = UUID()
    var name: String
    var players: [Player]
    var score: Int = 0
    var wickets: Int = 0
    var overs: Int = 0
    var balls: Int = 0
    var extras: Extras = Extras()
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var runs: Int = 0
    var ballsFaced: Int = 0
    var isCurrentlyBatting: Bool = false
}

struct Extras {
    var wides: Int = 0
    var noBalls: Int = 0
    var byes: Int = 0
    var legByes: Int = 0
    
    var total: Int {
        return wides + noBalls + byes + legByes
    }
}

struct CricketScoreView: View {
    @State private var teams: [Team] = [
        Team(name: "Team A", players: []),
        Team(name: "Team B", players: [])
    ]
    @State private var currentTeamIndex = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showExtrasSheet = false
    @State private var showTeamSheet = false
    @State private var showPlayerSheet = false
    @State private var newPlayerName = ""
    @State private var targetScore: Int? = nil
    
    var currentTeam: Binding<Team> {
        $teams[currentTeamIndex]
    }
    
    let gradientColors = [
        Color(hex: "1E2B6F"),
        Color(hex: "193469"),
        Color(hex: "12264A")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: gradientColors),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Team Selector
                        Picker("Select Team", selection: $currentTeamIndex) {
                            ForEach(teams.indices, id: \.self) { index in
                                Text(teams[index].name).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Score Card
                        VStack(spacing: 15) {
                            Text(currentTeam.wrappedValue.name)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 30) {
                                // Runs/Wickets
                                VStack {
                                    Text("\(currentTeam.wrappedValue.score)/\(currentTeam.wrappedValue.wickets)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("RUNS/WICKETS")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                // Overs
                                VStack {
                                    Text("\(currentTeam.wrappedValue.overs).\(currentTeam.wrappedValue.balls)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("OVERS")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            // Extras Display
                            Text("Extras: \(currentTeam.wrappedValue.extras.total)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            if let target = targetScore {
                                Text("Target: \(target)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Current Batsmen
                        if !currentTeam.wrappedValue.players.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Batsmen")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(currentTeam.wrappedValue.players.filter { $0.isCurrentlyBatting }) { player in
                                    HStack {
                                        Text(player.name)
                                        Spacer()
                                        Text("\(player.runs)(\(player.ballsFaced))")
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                        
                        // Run Buttons
                        VStack(spacing: 15) {
                            Text("ADD RUNS")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                ForEach([0, 1, 2, 3, 4, 6], id: \.self) { run in
                                    Button(action: { addRuns(run) }) {
                                        Text("\(run)")
                                            .font(.headline)
                                            .foregroundColor(Color(hex: "193469"))
                                            .frame(width: 50, height: 50)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Extra Runs and Wickets
                        HStack(spacing: 15) {
                            Button(action: { showExtrasSheet = true }) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                    Text("Extras")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.12))
                                .cornerRadius(12)
                            }
                            
                            Button(action: { addWicket() }) {
                                VStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                    Text("Wicket")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.12))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Control Buttons
                        HStack(spacing: 15) {
                            Button(action: { undoLastAction() }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("Undo")
                                }
                                .foregroundColor(Color(hex: "193469"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: { resetScore() }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Reset")
                                }
                                .foregroundColor(Color(hex: "193469"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 30)
                }
            }
            .navigationTitle("Cricket Scorer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Manage Players") { showPlayerSheet = true }
                        Button("Manage Teams") { showTeamSheet = true }
                        Button("Set Target") { showTargetAlert() }
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showExtrasSheet) {
                ExtrasView(team: currentTeam)
            }
            .sheet(isPresented: $showPlayerSheet) {
                PlayerManagementView(team: currentTeam)
            }
            .sheet(isPresented: $showTeamSheet) {
                TeamManagementView(teams: $teams)
            }
        }
    }
    
    // MARK: - Functions
    
    private func addRuns(_ run: Int) {
        currentTeam.wrappedValue.score += run
        incrementBall()
        
        // Update current batsman's score
        if let index = currentTeam.wrappedValue.players.firstIndex(where: { $0.isCurrentlyBatting }) {
            currentTeam.wrappedValue.players[index].runs += run
            currentTeam.wrappedValue.players[index].ballsFaced += 1
        }
    }
    
    private func incrementBall() {
        currentTeam.wrappedValue.balls += 1
        if currentTeam.wrappedValue.balls == 6 {
            currentTeam.wrappedValue.balls = 0
            currentTeam.wrappedValue.overs += 1
        }
    }
    
    private func addWicket() {
        if currentTeam.wrappedValue.wickets < 10 {
            currentTeam.wrappedValue.wickets += 1
            incrementBall()
            
            // Update batsman status
            if let index = currentTeam.wrappedValue.players.firstIndex(where: { $0.isCurrentlyBatting }) {
                currentTeam.wrappedValue.players[index].isCurrentlyBatting = false
            }
        }
    }
    
    private func undoLastAction() {
        // Implement undo logic
    }
    
    private func resetScore() {
        currentTeam.wrappedValue.score = 0
        currentTeam.wrappedValue.wickets = 0
        currentTeam.wrappedValue.overs = 0
        currentTeam.wrappedValue.balls = 0
        currentTeam.wrappedValue.extras = Extras()
        
        // Reset player scores
        for index in currentTeam.wrappedValue.players.indices {
            currentTeam.wrappedValue.players[index].runs = 0
            currentTeam.wrappedValue.players[index].ballsFaced = 0
        }
    }
    
    private func showTargetAlert() {
        // Implement target setting logic
    }
}

// MARK: - Supporting Views

struct ExtrasView: View {
    @Binding var team: Team
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Extras")) {
                    HStack {
                        Text("Wides")
                        Stepper("\(team.extras.wides)", value: $team.extras.wides)
                    }
                    
                    HStack {
                        Text("No Balls")
                        Stepper("\(team.extras.noBalls)", value: $team.extras.noBalls)
                    }
                    
                    HStack {
                        Text("Byes")
                        Stepper("\(team.extras.byes)", value: $team.extras.byes)
                    }
                    
                    HStack {
                        Text("Leg Byes")
                        Stepper("\(team.extras.legByes)", value: $team.extras.legByes)
                    }
                }
            }
            .navigationTitle("Manage Extras")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlayerManagementView: View {
    @Binding var team: Team
    @Environment(\.dismiss) var dismiss
    @State private var newPlayerName = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Player")) {
                    HStack {
                        TextField("Player Name", text: $newPlayerName)
                        Button("Add") {
                            if !newPlayerName.isEmpty {
                                team.players.append(Player(name: newPlayerName))
                                newPlayerName = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Players")) {
                    ForEach(team.players) { player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            if player.isCurrentlyBatting {
                                Image(systemName: "bat.fill")
                            }
                        }
                    }
                    .onDelete { indexSet in
                        team.players.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Manage Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TeamManagementView: View {
    @Binding var teams: [Team]
    @Environment(\.dismiss) var dismiss
    @State private var newTeamName = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Team")) {
                    HStack {
                        TextField("Team Name", text: $newTeamName)
                        Button("Add") {
                            if !newTeamName.isEmpty {
                                teams.append(Team(name: newTeamName, players: []))
                                newTeamName = ""
                            }
                        }
                    }
                }
                
                Section(header: Text("Teams")) {
                    ForEach(teams) { team in
                        Text(team.name)
                    }
                    .onDelete { indexSet in
                        teams.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle("Manage Teams")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}