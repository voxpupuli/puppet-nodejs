# frozen_string_literal: true

def purge_node
  case fact('osfamily')
  when 'Debian'
    on default, 'apt-get purge -y libnode* nodejs-legacy', { acceptable_exit_codes: [0, 100] }
  end
end
