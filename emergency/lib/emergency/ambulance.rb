module Emergency

  class Ambulance
    include Positioning
    include ActsAsNamed

    LOAD_TIME   = 1
    UNLOAD_TIME = 1
    MAX_LOAD    = 4

    attr_accessor :time, :patients, :hospital

    def self.next
      return nil if !all.any?(&:available?)
      ambulance = nil
      while ambulance.nil?
        i = rand(all.size)
        ambulance = all.detect { |a| all.index(a) == i && a.available? }
      end
      ambulance
    end

    def initialize(hospital)
      @hospital = hospital
      reset
    end

    def reset
      @position = @hospital.position
      @time = 0
      @patients = []
      @log = []
      @available = true
    end

    def save_cluster
      people = find_people
      while person = next_saveable(people)
        pickup person

        while @patients.size < MAX_LOAD do
          people = find_people
          person = next_saveable(people)
          break if person.nil?
          if time_to_save_person(person) < time_left_for_patients?
            pickup person
          else
            break
          end
        end

        unload
      end
      @available = false
    end

    def time_left_for_patients?
      return 10000000 if @patients.empty?
      @patients.map{ |p| p.time_left(time) }.min
    end

    def next_saveable(people)
      saveables = people.select { |p|
          p.alive?(time) && !p.dropped? && !patient?(p) && time_to_save_person(p) <= p.time_left(time)
        }
      weighted_saveables = saveables.map do |s|
        score = edge_to(s).count + (Person.max_time/(s.time_left(time) + 1)).to_i
        Array.new(score, s)
      end
      weighted_saveables.flatten!
      weighted_saveables[rand(weighted_saveables.size)]
    end

    def available?
      @available
    end

    def pickup(person)
      tick distance_to(person) + LOAD_TIME
      travel_to person.position
      @patients << person
      Logger.record "#{display_name} #{person.display_name}"
    end

    def unload
      hospital = nearest_hospital
      tick distance_to(hospital) + UNLOAD_TIME
      travel_to hospital.position
      @patients.each { |p| p.drop_at(hospital) }
      Logger.record "#{display_name} (#{hospital.to_coord.join(',')})"
      @patients = []
    end

    def time_to_save_person(person)
      distance_to(person) + LOAD_TIME + person.hospital_distance + UNLOAD_TIME
    end

    def viability(person)
      person.time_left(time) / distance_to(person)
    end

    def patient?(person)
      @patients.include? person
    end

    def display_name
      "Ambulance #{name}"
    end

    def tick(time)
      @time += time
    end
    
    def find_people
      other_hosps = (Hospital.all - [nearest_hospital])
      nearest_hospital.cluster + other_hosps[rand(other_hosps.size)].cluster
    end

  end

end