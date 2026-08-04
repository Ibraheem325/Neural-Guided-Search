(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	Star0 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star7 - direction
	Star11 - direction
	Star13 - direction
	Star14 - direction
	GroundStation12 - direction
	Star16 - direction
	Star17 - direction
	Star2 - direction
	GroundStation9 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	Star15 - direction
	GroundStation5 - direction
	Phenomenon18 - direction
	Planet19 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation10)
	(supports instrument1 thermograph1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star17)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star16)
	(supports instrument2 thermograph1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation5)
	(calibration_target instrument2 Star15)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 GroundStation9)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
)
(:goal (and
	(pointing satellite1 Star2)
	(have_image Phenomenon18 thermograph1)
	(have_image Planet19 thermograph1)
))

)
