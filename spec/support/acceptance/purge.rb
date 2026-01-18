# frozen_string_literal: true

def purge_node
  case fact('osfamily')
  when 'Debian'
    on default, 'apt-get purge -y libnode*', { acceptable_exit_codes: [0, 100] }
  end
end
