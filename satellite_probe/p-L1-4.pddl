(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	thermograph0 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	Star2 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	Star1 - direction
	Star0 - direction
	GroundStation7 - direction
	GroundStation4 - direction
	Phenomenon10 - direction
	Star11 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star2)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation7)
	(calibration_target instrument2 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon10)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(have_image Phenomenon10 thermograph0)
	(have_image Star11 infrared2)
	(have_image Phenomenon12 infrared1)
	(have_image Planet13 infrared2)
	(have_image Planet14 thermograph0)
))

)
