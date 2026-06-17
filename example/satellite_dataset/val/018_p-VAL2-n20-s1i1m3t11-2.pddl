(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared2 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	Planet11 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Planet11 spectrograph0)
	(have_image Phenomenon12 infrared2)
	(have_image Phenomenon13 infrared2)
	(have_image Star14 infrared2)
))

)
