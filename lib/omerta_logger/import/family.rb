module OmertaLogger
  module Import
    class Family < Base
      XML_MAPPING = { name:  'name', worth: 'worth', rank: 'rank', user_count: 'users', hq: 'hq',
                      color: 'color', bank: 'bank' }.freeze

      def get_user(ext_user_id, name)
        @version.users.find_or_create_by(ext_user_id: ext_user_id, name: name)
      end

      def import
        import_families
        import_deaths
        import_tops
      end

      def import_families
        @alive_families = []
        @xml.css('families family').each do |xml_family|
          @alive_families << xml_family['id']
          family = @version.families.find_or_create_by(ext_family_id: xml_family['id'])
          newfam = { city:       enumify(xml_family.css('city').text),
                     alive:      true,
                     first_seen: family.first_seen || @loader.generated }
          XML_MAPPING.each do |k, v|
            newfam[k] = xml_family.css(v).text
          end
          family.update_attributes(newfam)
          Rails.logger.debug "imported family #{family.name}"
        end
        set_position
      end

      def set_position
        @version.families.where(alive: true).order(worth: :desc).each_with_index do |f, i|
          f.position = i + 1
          f.save
          Rails.logger.debug "family #{f.name}: set position #{f.position}"
        end
      end

      def import_tops
        @xml.css('families family').each do |xml_family|
          family        = @version.families.find_by_ext_family_id(xml_family['id'])
          family.don    = get_user(xml_family.at_css('boss')['id'].to_i, xml_family.at_css('boss').text)
          family.sotto  = get_user(xml_family.at_css('sotto')['id'].to_i, xml_family.at_css('sotto').text)
          family.consig = get_user(xml_family.at_css('consig')['id'].to_i, xml_family.at_css('consig').text)
          family.save
          Rails.logger.debug "set family tops for family #{family.name}"
        end
      end

      def import_deaths
        @xml.css('family_deaths family').each do |xml_family|
          family = @version.families.where(
            name: xml_family.css('name').text
          ).where(
            'first_seen <= ?', Time.zone.at(xml_family.css('time').text.to_i)
          ).where(
            # prevents a race condition when fam is renamed to a downed fam
            'id NOT IN (?)', @alive_families
          ).order(
            'first_seen DESC'
          ).first

          family = @version.families.new if family.nil?
          family.name       = xml_family.css('name').text
          family.alive      = false
          family.rip_topic  = xml_family.css('riptopic').text
          family.death_date = Time.zone.at(xml_family.css('time').text.to_i)
          family.save
          Rails.logger.debug "marked family #{family.name} as down"
        end
      end
    end
  end
end
