Config = {}

-- The frequency that requires authorization to speak on
Config.RestrictedFrequency = '100.0'

-- The job name that is authorized to grant radio access
Config.AuthorizedJob = 'police'

-- The minimum grade level required to grant radio access
Config.RequiredGrade = 4

-- Locales
Config.Locales = {
    ['must_be_in_vehicle'] = 'You must be in a vehicle to use the car radio.',
    ['access_granted'] = 'You have granted radio access to player %s.',
    ['access_revoked'] = 'You have revoked radio access for player %s.',
    ['your_access_granted'] = 'You have been granted radio access.',
    ['your_access_revoked'] = 'Your radio access has been revoked.',
    ['player_not_found'] = 'Player not found.',
    ['invalid_player_id'] = 'Invalid player ID.',
    ['not_authorized_command'] = 'You are not authorized to use this command.',
    ['not_authorized_frequency'] = 'You are not authorized to speak on this frequency.'
}