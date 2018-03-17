# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'shared_configuration_context'

describe Typesense::Debug do
  include_context 'Typesense configuration'

  subject(:debug) { typesense.debug }

  describe '#retrieve' do
    it 'retrieves debugging information' do
      debug_info = {
        'version' => '0.8.0'
      }
      stub_request(:get, Typesense::ApiCall.new(typesense.configuration).send(:uri_for, '/debug'))
        .with(headers: {
                'X-Typesense-Api-Key' => typesense.configuration.master_node[:api_key]
              })
        .to_return(status: 200, body: JSON.dump(debug_info), headers: { 'Content-Type': 'application/json' })

      result = debug.retrieve

      expect(result).to eq(debug_info)
    end
  end
end