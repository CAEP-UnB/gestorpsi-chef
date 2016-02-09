name 'gestorpsi_server'
description 'GestorPSI Server'

run_list *[
    'recipe[basics]',
    'recipe[postgresql]',
]