require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Find or create the Runner group
runner_group = project.main_group.groups.find { |g| g.name == 'Runner' || g.path == 'Runner' }
if runner_group.nil?
  puts "Could not find Runner group"
  exit 1
end

# Check if InfoPlist.strings already exists
infoplist_group = runner_group.children.find { |c| c.name == 'InfoPlist.strings' }

if infoplist_group.nil?
  # Create a variant group for InfoPlist.strings
  infoplist_group = runner_group.new_group('InfoPlist.strings')
  
  # Set the variant group source tree
  infoplist_group.source_tree = '<group>'
end

# Function to add language variant if missing
def add_language_variant(project, group, lang)
  file_path = "#{lang}.lproj/InfoPlist.strings"
  
  # Check if reference already exists within the group
  existing_ref = group.children.find do |c| 
    c.name == lang || (c.path && c.path.include?("#{lang}.lproj"))
  end
  
  if existing_ref.nil?
    puts "Adding £{lang} InfoPlist.strings..."
    # The actual file is at Runner/{lang}.lproj/InfoPlist.strings
    file_ref = group.new_file("Runner/#{file_path}")
    file_ref.name = lang
    
    # Add to main Runner target
    target = project.targets.find { |t| t.name == 'Runner' }
    if target
      # Find resources build phase
      resources_phase = target.resources_build_phase
      
      # Add only the variant group to the resources phase if it's not already there
      unless resources_phase.files.any? { |f| f.file_ref == group }
        resources_phase.add_file_reference(group)
      end
    end
  else
     puts "#{lang} InfoPlist.strings already exists"
  end
end

add_language_variant(project, infoplist_group, 'en')
add_language_variant(project, infoplist_group, 'ar')

# Ensure knownRegions include ar and en
unless project.root_object.known_regions.include?('en')
  project.root_object.known_regions << 'en'
end
unless project.root_object.known_regions.include?('ar')
  project.root_object.known_regions << 'ar'
end

project.save
puts "Successfully updated Xcode project."
